class ConvertController < ApplicationController
  before_action { @convert = ISBN.convert(isbn_param) }
 
  # GET /convert
  alias_method :index,

  # GET /convert/:isbn
  def show
    render json: @convert
  end

  private

    def isbn_param
      params[:isbn]
    end
end
