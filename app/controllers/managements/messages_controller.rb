class Managements::MessagesController < ApplicationController
  layout 'management'
  before_action :authenticate_manager!

  def index
    @messages = Message.order(created_at: :desc).page(params[:page])
  end

  def show
    @message = Message.find params[:id]
    @message.read!
  end

  def destroy
  end
end
