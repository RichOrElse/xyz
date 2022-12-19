class ApiController < ApplicationController
  def index
    render json: {
      book_url: "#{books_url}/{isbn13}",
      convert_url: "#{convert_index_url}/{isbn}"
    }
  end
end
