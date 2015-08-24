class Api::V1::ProductsController < Api::V1::ApiController
  def index
    render json: Product.available.all, each_serializer: Api::V1::ProductSerializer, status: 200
  end
end
