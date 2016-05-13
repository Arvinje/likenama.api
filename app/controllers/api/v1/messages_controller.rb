class Api::V1::MessagesController < Api::V1::ApiController

  def create
    message = current_user.messages.build(message_params)
    if message.save
      head :created
    else
      render json: { errors: message.errors }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end
