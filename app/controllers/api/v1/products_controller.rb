class Api::V1::ProductsController < Api::V1::ApiController
  def index
    render json: Product.available.all, status: 200
  end
end
