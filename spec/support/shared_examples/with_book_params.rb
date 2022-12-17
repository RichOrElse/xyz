# frozen_string_literal: true

RSpec.shared_context "with book params" do
  let(:book_params) { { publisher: publisher, authors: book_authors, isbn13: isbn13, title: title, publication_year: 2022, list_price: "3000.0" } }
  let(:other_book_params) { book_params.merge(isbn13: "978-0-306-40615-7") }
  let(:publisher) { Publisher.new(name: "McSweeney’s") }
  let(:isbn13) { "978-1-603095-13-6" }
  let(:title) { "Doughnuts And Doom" }
  let(:book_authors) { Author.create! book_author_names.map(&FullName).map(&:to_h) }
  let(:book_author_names) { ["Hannah P. Templer", "Marguerite Z. Duras", "Iceberg Nash Slim", "Camille Byron Paglia"] }
end
