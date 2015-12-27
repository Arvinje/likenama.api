class Managements::ProductTypesController < ApplicationController
  layout 'management'
  before_action :get_product_types, only: [:index]
  before_action :find_product_type, only: [:update, :destroy]

  def index
    puts params.inspect
    @product_type = if params[:id]
                          ProductType.find(params[:id])
                        else
                          ProductType.new
                        end
  end

  def create
    @product_type = ProductType.new(product_type_params)
    if @product_type.save
      redirect_to management_product_types_path
    else
      get_product_types
      render 'index'
    end
  end

  def update
    if @product_type.update_attributes(product_type_params)
      redirect_to management_product_types_path
    else
      get_product_types
      render 'index'
    end
  end

  def destroy
    @product_type.destroy
    redirect_to management_product_types_path
  end

  private

  def product_type_params
    params.require(:product_type).permit(:name)
  end

  def get_product_types
    @product_types = ProductType.last 10
  end

  def find_product_type
    @product_type = ProductType.find(params[:id])
  end
end
