class ApiController < ApplicationController
  def index
    render json: {
      book_url: "#{book_index_url}/{isbn13}",
      convert_url: "#{convert_index_url}/{isbn}"
    }
  end
end
