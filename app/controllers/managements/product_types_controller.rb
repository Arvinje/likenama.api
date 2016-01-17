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
    if @product_type.save
      @product_type.create_activity :created, owner: current_manager
      reset_product_type
    end
  end

  def edit
  end

  def update
    if @product_type.update_attributes(product_type_params)
      @product_type.create_activity :updated, owner: current_manager
      reset_product_type
    end
  end

  def destroy
    @product_type.create_activity :destroyed, owner: current_manager
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
