module ISBN
  ZERO_IF_TEN = { 10 => 0 }.freeze
  ZERO_IF_ELEVEN_OR_X_IF_TEN = { 11 => 0, 10 => "X" }.freeze
  TO_PRODUCT = proc { |(digit, cycle)| digit * cycle }

  def valid?(isbn)
    return false unless isbn.to_s.starts_with? /(978|979)/
    return false if (normalized = normalize(isbn)).length < 13

    check_thirteen(*digitize(normalized))
  end

  def invalid?(isbn)
    !valid?(isbn)
  end

  def check_thirteen(*digits, check_digit)
    result = checksum_thirteen(digits)
    result = ZERO_IF_TEN.fetch(result, result)
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
    isbn << ZERO_IF_TEN.fetch(check_digit, check_digit).to_s
  end

  def ten(isbn)
    return "" if (isbn = normalize(isbn)).starts_with?("979")
    return "" if (isbn = skew(isbn)).empty?

    check_digit = checksum_ten(digitize(isbn))
    isbn << ZERO_IF_ELEVEN_OR_X_IF_TEN.fetch(check_digit, check_digit).to_s
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
    when 13 then isbn.scan(/(...)(.)(...)(.....)(.)/).join("-")
    when 10 then isbn.scan(/(.)(...)(.....)(.)/).join("-")
    else ""
    end
  end

  def adjust(isbn)
    isbn.rjust(13, "978").chop
  end

  def skew(isbn)
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
