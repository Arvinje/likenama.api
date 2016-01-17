class Managements::ProductsController < ApplicationController
  layout 'management'

  before_action :authenticate_manager!
  before_action :find_product, only: [:edit, :update, :show, :destroy]

  def index
    @products = Product.order(created_at: :desc).includes(:product_type).page(params[:page])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      @product.create_activity :created, owner: current_manager
      redirect_to [:management, @product]
    else
      render 'new'
    end
  end

  def show
    @product_details = @product.details.order(created_at: :desc).includes(:product).page(params[:page])
    @product_detail = @product.details.build
  end

  def edit
    @product = Product.find params[:id]
  end

  def update
    if @product.update_attributes(product_params)
      @product.create_activity :updated, owner: current_manager
      redirect_to [:management, @product]
    else
      render 'edit'
    end
  end

  def destroy
    @product.create_activity :destroyed, owner: current_manager
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :description, :product_type_id, :available).fix_numerals
  end

  def find_product
    @product = Product.find params[:id]
  end
end
