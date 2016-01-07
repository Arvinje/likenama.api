class Api::V1::ProductsController < Api::V1::ApiController
  def index
    products = Product.available.all.includes(:product_type)
    unless products.empty?
      render json: products, each_serializer: Api::V1::ProductSerializer, status: :ok
    else
      handle_notfound
    end
  end
end
