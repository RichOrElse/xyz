class BooksController < ApplicationController
  # GET /books/:isbn
  def show
    if @book = BookRepository.at(params[:isbn])
      render json: @book.then(&BookPresenter)
    else
      render json: { error: "not found" }, status: 404
    end
  end
end
