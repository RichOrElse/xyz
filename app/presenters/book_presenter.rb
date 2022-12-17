class BookPresenter < Struct.new(:isbn13, :title, :publisher_name, :authors, :publication_year, :list_price, :updated_at, :created_at, keyword_init: true)
  def initialize(book)
    super book.slice(*members).merge(authors: AuthorsPresenter.new(book.authors).to_s)
  end

  def self.to_proc
    method(:new).to_proc
  end
end
