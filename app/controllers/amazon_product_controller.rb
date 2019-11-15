class AmazonProductController < ApplicationController

  def index
    render json: {
      welcome: 'ola k ase?'
    }
  end

  def show
    render json: {
      show: 'ola k kiere?'
    }
  end
end
