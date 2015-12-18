class Managements::MessagesController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!

  def index
  end

  def show
    params[:id]
    @user = User.last
  end

  def destroy
  end
end
