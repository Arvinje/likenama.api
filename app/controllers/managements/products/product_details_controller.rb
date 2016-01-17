class Managements::Products::ProductDetailsController < ApplicationController
  before_action :authenticate_manager!
  before_action :find_product_detail, only: [:edit, :update]

  def edit
  end

  def create
    @product = Product.find params[:product_id]
    @product_detail = @product.details.build(details_params)
    if @product_detail.save
      @product_detail.create_activity :created, owner: current_manager
      @product_detail = @product.details.build
    end
    all_product_details
  end

  def update
    @product = @product_detail.product
    if @product_detail.update_attributes(details_params)
      @product_detail.create_activity :updated, owner: current_manager
      @product_detail = @product.details.build
    end
    all_product_details
  end

  private

  def details_params
    params.require(:product_detail).permit(:code, :available).fix_numerals
  end

  def find_product_detail
    @product_detail = ProductDetail.find params[:id]
  end

  def all_product_details
    @product_details = @product.details.order(created_at: :desc).page(params[:page])
  end
end
