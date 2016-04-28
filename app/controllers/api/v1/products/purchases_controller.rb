class Api::V1::Products::PurchasesController < Api::V1::ApiController

  def create
    product = Product.available.find params[:product_id]
    purchase = PurchaseProduct.new(current_user, product)
    if purchase.buy
      render json: purchase.purchased_detail, serializer: Api::V1::DetailSerializer, root: 'detail', status: :created
    else
      render json: { errors: purchase.user.errors }, status: :unprocessable_entity
    end
  end

end
