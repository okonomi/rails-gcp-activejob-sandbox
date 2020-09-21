class HelloController < ApplicationController
  def index
    render plain: "Hello, #{params[:name]}"
  end
end
