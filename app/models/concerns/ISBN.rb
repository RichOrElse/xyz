module ISBN
  ONLY_VALID_CHARACTERS = /^[Xx0-9\-\_]*$/
  DIGIT_FOR = Hash.new { |_, digit| digit }
  ZERO_IF_TEN = DIGIT_FOR.merge( 10 => 0 ).freeze
  TEN_IF_X = DIGIT_FOR.merge( "X" => 10 ).freeze
  ZERO_IF_ELEVEN_OR_X_IF_TEN = DIGIT_FOR.merge( 11 => 0, 10 => "X" ).freeze
  TO_PRODUCT = proc { |(digit, cycle)| digit * cycle }

  def convert(isbn)
    return { isbn10: "", isbn13: "" } unless ONLY_VALID_CHARACTERS.match?(isbn)

    case (isbn = normalize(isbn)).length
    when 11..13
      isbn10 = from13to10(isbn)
      isbn13 = thirteen(isbn)
    when 1..10
      isbn10 = ten(isbn)
      isbn13 = from10to13(isbn)
    else
      isbn10 = ""
      isbn13 = ""
    end

    {
      isbn10: dasherize(isbn10),
      isbn13: dasherize(isbn13)
    }
  end

  def from13to10(isbn)
    isbn = isbn.rjust(13, "0") if isbn.length < 13
    return "" unless isbn.start_with?("978")
    isbn = isbn.first(12).delete_prefix("978")
    digits = digitize(isbn)

    checksum = digits.zip(1..9).map(&TO_PRODUCT).sum % 11
    checksum = "X" if checksum == 10
    isbn << checksum.to_s
  end

  def from10to13(isbn)
    isbn = isbn.rjust(10, "0") if isbn.length < 10
    isbn = isbn.first(9).prepend("978")
    digits = digitize(isbn)

    checksum = digits.zip([1,3].cycle).map(&TO_PRODUCT).sum % 10
    checksum = 10 - checksum unless checksum.zero?
    isbn << checksum.to_s
  end

  def valid?(isbn)
    return false unless isbn.to_s.starts_with? /(978|979)/
    return false if (normalized = normalize(isbn)).length < 13

    check_thirteen(*digitize(normalized))
  end

  def invalid?(isbn)
    !valid?(isbn)
  end

  def ten_valid?(isbn)
    return false if (isbn = normalize(isbn)).length < 10

    check_digit = TEN_IF_X[isbn.last].to_i
    digits = digitize(isbn.chop)
    result = checksum_ten(digits)
    check_digit == result
  end

  def check_thirteen(*digits, check_digit)
    result = checksum_thirteen(digits)
    result = ZERO_IF_TEN[result]
    check_digit == result
  end

  def checksum_thirteen(digits)
    sum = digits.zip([1,3].cycle).map(&TO_PRODUCT).sum
    10 - (sum % 10)
  end

  def checksum_ten(digits)
    sum = digits.zip(10.downto(2)).map(&TO_PRODUCT).sum
    11 - (sum % 11)
  end

  def thirteen(isbn)
    return "" unless (isbn = normalize(isbn)).length.in?([10, 13])
    return "" unless (isbn = adjust(isbn)).length == 12

    check_digit = checksum_thirteen(digitize(isbn))
    isbn << ZERO_IF_TEN[check_digit].to_s
  end

  def ten(isbn)
    return "" if (isbn = normalize(isbn)).starts_with?("979")
    return "" if (isbn = trim(isbn)).empty?

    check_digit = checksum_ten(digitize(isbn))
    isbn << ZERO_IF_ELEVEN_OR_X_IF_TEN[check_digit].to_s
  end

  def normalize(isbn)
    isbn.to_s.delete("-").upcase
  end

  def digitize(normalized)
    normalized.each_char.map(&:to_i)
  end

  def dasherize(isbn)
    isbn = normalize(isbn)
    case isbn.length
    when 13 then isbn.scan(/(...)(.)(......)(..)(.)/).join("-")
    when 10 then isbn.scan(/(.)(...)(.....)(.)/).join("-")
    else ""
    end
  end

  def adjust(isbn)
    isbn.rjust(13, "978").chop
  end

  def trim(isbn)
    case isbn.length
    when 13 then isbn.delete_prefix("978").first(9)
    when 10 then isbn.first(9)
    else ""
    end
  end

  module_function *public_instance_methods(:false)

  class Validator < ActiveModel::Validator
    def validate(record)
      if ISBN.invalid?(record.isbn13)
        record.errors.add :isbn13, :invalid
      end
    end
  end

  class ThirteenTaken < ActiveRecord::RecordNotUnique
    def ===(not_unique)
      super && not_unique.message.ends_with?("UNIQUE constraint failed: index 'normalized_isbn13_uniq_idx'")
    end
  end
end
