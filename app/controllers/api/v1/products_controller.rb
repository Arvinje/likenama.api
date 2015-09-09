class Api::V1::ProductsController < Api::V1::ApiController
  def index
    products = Product.available.all
    unless products.empty?
      render json: Product.available.all, each_serializer: Api::V1::ProductSerializer, status: :ok
    else
      handle_notfound
    end
  end
end
