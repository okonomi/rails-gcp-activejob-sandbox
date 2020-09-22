require 'base64'
require 'json'

class HelloController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    HelloJob.perform_later params[:name]

    render plain: "Enqueued!"
  end

  def worker
    data = Base64.decode64(message_params[:data])
    message = JSON.parse(data)
    message['job_class'].constantize.public_send(:perform_now, *message['arguments'])

    render plain: "Executed!", status: :created
  rescue e
    p e
  end

  private

  def message_params
    params.require(:message).permit(:data)
  end
end
