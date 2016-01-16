class Managements::ProductTypesController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!
  before_action :all_product_types
  before_action :find_product_type, only: [:edit, :update, :destroy]

  def index
    reset_product_type
  end

  def create
    @product_type = ProductType.new(product_type_params)
    reset_product_type if @product_type.save
  end

  def edit
  end

  def update
    reset_product_type if @product_type.update_attributes(product_type_params)
  end

  def destroy
    @product_type.destroy
  end

  private

  def product_type_params
    params.require(:product_type).permit(:name)
  end

  def all_product_types
    @product_types = ProductType.order(created_at: :asc).page(params[:page])
  end

  def find_product_type
    @product_type = ProductType.find(params[:id])
  end

  def reset_product_type
    @product_type = ProductType.new
  end
end
