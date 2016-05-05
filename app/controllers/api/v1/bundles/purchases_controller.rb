class Api::V1::Bundles::PurchasesController < Api::V1::ApiController

  def create
    bundle = Bundle.active.find_by! bazaar_sku: params[:bazaar_sku]
    purchase = PurchaseBundle.new(current_user, bundle, purchase_params[:purchase_token])
    if purchase.buy
      render json: current_user, serializer: Api::V1::UserSerializer, status: :created
    else
      render json: { errors: purchase.user.errors }, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.require(:bundle).permit(:purchase_token)
  end

end
