class BooksController < ApplicationController
  before_action -> { render json: { error: "invalid ISBN-13" }, status: 400 if ISBN.invalid?(params[:isbn]) }

  # GET /books
  alias_method :index,

  # GET /books/:isbn
  def show
    if @book = BookRepository.at(params[:isbn])
      render json: @book.then(&BookPresenter)
    else
      render json: { error: "not found" }, status: 404
    end
  end
end
