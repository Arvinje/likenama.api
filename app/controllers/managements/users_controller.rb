class Managements::UsersController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!
  before_action :get_user, only: [:show, :lock, :unlock]

  def index
    @users = User.order(created_at: :desc).take(10)
  end

  def show
  end

  def lock
    @user.lock_access!({ send_instructions: false })
    @user.create_activity :lock, owner: current_manager
    redirect_to management_user_path(@user)
  end

  def unlock
    @user.unlock_access!
    @user.create_activity :unlock, owner: current_manager
    redirect_to management_user_path(@user)
  end

  def update
  end

  private

  def get_user
    @user = User.find params[:id]
  end
end
