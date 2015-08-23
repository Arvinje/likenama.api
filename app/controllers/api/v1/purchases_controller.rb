class Api::V1::PurchasesController < Api::V1::ApiController
  before_action :validate_product

  def create
    if purchased_detail = current_user.buy(Product.find_by(id: params[:product_id]))
      render json: purchased_detail, serializer: DetailSerializer, root: 'details'
    else
      render json: { errors: current_user.errors }, status: 422
    end
  end

  private

  def validate_product
    if Product.find_by(id: params[:product_id]).nil?
      errors = { base: ["wrong product_id"] }
      render json: { errors: errors }, status: 422
    end
  end
end
