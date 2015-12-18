class Managements::Products::ProductDetailsController < ApplicationController
  before_action :authenticate_manager!
  
  def create
    @product_detail = Product.find(params[:product_id]).details.build(details_params)
    if @product_detail.save
    end
    redirect_to management_product_path(@product_detail.product)
  end

  def update
    @product_detail = ProductDetail.find(params[:id])
    if @product_detail.update_attributes(details_params)
    end
    redirect_to management_product_path(@product_detail.product)
  end

  private

  def details_params
    params.require(:product_detail).permit(:code, :available)
  end
end
