require 'rails_helper'

RSpec.describe BookRepository, type: :repository do
  include_context "with book params"
  let!(:book) { Book.create!(book_params) }

  describe "with" do
    it { expect(BookRepository.with(book.isbn13)).to include(book) }
    it { expect(BookRepository.with(book.isbn13.downcase)).to include(book) }
    it { expect(BookRepository.with(book.isbn13.delete("-"))).to include(book) }
    it { expect(BookRepository.with(book.isbn13.reverse)).to be_empty }
  end

  describe "<<" do
    it { expect(BookRepository << book).to be_a(BookRepository) }
    it { expect { BookRepository << Book.new(other_book_params) }.to change(Book, :count) }
    it { expect { BookRepository << Book.new(book.attributes) }.to_not change(Book, :count) }
    it { expect { BookRepository << book.tap { book.title = "Changed" } }.to change { book.reload.title } }
  end
end
