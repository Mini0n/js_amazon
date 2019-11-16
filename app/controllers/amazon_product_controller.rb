class AmazonProductController < ApplicationController
  before_action :init_product

  def index
    @products = @product.get_all_json

    render json: {
      status: 200,
      products: @products,
      error: ''
    }
  end

  def show
    @products = @product.get_product(product_params[:asin])

    render json: { status: 200 }.merge!(@products)
  end

  def init_product
    @product = AmazonProduct.new
  end

  def product_params
    params.permit(:asin)
  end
end
