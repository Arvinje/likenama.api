class Managements::MessagesController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!

  def index
    @messages = Message.order(created_at: :desc).includes(:user).page(params[:page])
  end

  def show
    @message = Message.find params[:id]
    @message.read!
    @message.create_activity :read, owner: current_manager if @message.unread?
  end

  def destroy
  end
end
