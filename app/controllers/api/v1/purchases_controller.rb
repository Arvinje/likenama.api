class Api::V1::PurchasesController < Api::V1::ApiController

  def create
    product = Product.find params[:product_id]
    if purchased_detail = current_user.buy(product)
      render json: purchased_detail, serializer: Api::V1::DetailSerializer, root: 'details', status: :created
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

end
