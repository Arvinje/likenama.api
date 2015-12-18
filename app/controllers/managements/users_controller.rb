class Managements::UsersController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!
  
  def index
    @users = User.order(created_at: :desc).take(10)
  end

  def show
    @user = User.find params[:id]
  end

  def update
  end
end
