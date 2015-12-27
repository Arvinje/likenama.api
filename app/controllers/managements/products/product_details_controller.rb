class Managements::Products::ProductDetailsController < ApplicationController
  before_action :authenticate_manager!

  def create
    @product = Product.find(params[:product_id])
    @product_detail = @product.details.build(details_params)
    if @product_detail.save
      redirect_to management_product_path(@product)
    else
      get_product_details
      render 'managements/products/show', id: @product.id, layout: 'management'
    end
  end

  def update
    @product_detail = ProductDetail.find(params[:id])
    @product = @product_detail.product
    if @product_detail.update_attributes(details_params)
      redirect_to management_product_path(@product)
    else
      get_product_details
      render 'managements/products/show', id: @product.id, layout: 'management'
    end
  end

  private

  def details_params
    params.require(:product_detail).permit(:code, :available).fix_numerals
  end

  def get_product_details
    @product_details = @product.details.order(created_at: :desc).page(params[:page])
  end
end
