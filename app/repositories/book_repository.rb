class BookRepository < Repository
  def initialize(books = Book.all, key: :isbn13)
    super
  end

  def with(isbn)
    where("#{index_for(:normalized_isbn13_uniq_idx).columns} = :isbn", isbn: ISBN.normalize(isbn))
  end

  def <<(book)
    super
  rescue ActiveRecord::RecordNotUnique => not_unique
    book.errors.add(:isbn13, :taken) if not_unique.message.include? "normalized_isbn13_uniq_idx"
  ensure
    self
  end

  module ISBN
    def self.normalize(isbn)
      isbn.to_s.delete('-').upcase
    end
  end
end
