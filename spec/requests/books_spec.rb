require 'rails_helper'

RSpec.describe "Books", type: :request do
  include_context "with book params"
  let!(:book) { Book.create(book_params) }

  describe "GET /books/:isbn" do
    it "returns http 200" do
      get book_path(book.isbn13) 
      expect(response).to have_http_status(200)
      expect(json_response).to include(
        **book_params.except(:publisher),
        publisher_name: publisher.name,
        authors: book_author_names.join(", ")
      )
    end

    context "when book does not exist" do
      it "returns http 404" do
        get book_path(other_book_params[:isbn13])
        expect(response).to have_http_status(404)
      end
   end
  end
end
