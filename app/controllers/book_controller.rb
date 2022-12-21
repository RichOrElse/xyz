class BookController < ApplicationController
  before_action -> { render json: { error: "invalid ISBN-13" }, status: 400 if ISBN.invalid?(params[:isbn]) }

  # GET /book
  alias_method :index,

  # GET /book/:isbn
  def show
    if @book = books.at(params[:isbn])
      render json: @book.then(&BookPresenter)
    else
      render json: { error: "not found" }, status: 404
    end
  end

  private
    def books
      BookRepository.new(Book.includes(:publisher, :authors))
    end
end
