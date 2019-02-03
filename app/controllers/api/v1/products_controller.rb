class Api::V1::ProductsController < ApplicationController
  respond_to :json

  def show
    respond_with Product.find(params[:id])
  end

  def index
    render json: { products: Product.all  }
  end
end
