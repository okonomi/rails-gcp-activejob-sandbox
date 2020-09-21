class HelloController < ApplicationController
  def index
    HelloJob.perform_later params[:name]

    render plain: "Enqueued!"
  end
end
