require 'rails_helper'

RSpec.describe "Convert", type: :request do
  let(:isbn10) { "0-306-40615-2" }
  let(:isbn13) { "978-0-306406-15-7" }


  describe "GET /convert/:isbn" do
    before do
      get "/convert"
      expect(response).to have_http_status(:success)
    end

    it "won't convert" do
      expect(json_response).to eq(isbn10: "", isbn13: "")
    end
  end
  
  describe "GET /convert/:isbn" do
    before do
      get convert_path(isbn_param)
      expect(response).to have_http_status(:success)
    end

    context "with ISBN-13" do
      let(:isbn_param) { isbn13 }

      it "converts to ISBN-10" do
        expect(json_response).to eq(isbn10: isbn10, isbn13: isbn13)
      end
    end

    context "with ISBN-10" do
      let(:isbn_param) { isbn10 }

      it "converts to ISBN-13" do
        expect(json_response).to eq(isbn10: isbn10, isbn13: isbn13)
      end
    end

    context "with ISBN-10 spaced" do
      let(:isbn_param) { isbn10.gsub("-", " ") }

      it "won't convert" do
        expect(json_response).to eq(isbn10: "", isbn13: "")
      end
    end
  end
end
