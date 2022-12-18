class ConvertController < ApplicationController
  before_action { @convert = ISBN.convert(isbn_param) }
 
  # GET /isbn
  def index
    render json: @convert
  end

  # GET /isbn/:isbn
  def show
    render json: @convert
  end

  private

    def isbn_param
      params[:isbn]
    end
end
