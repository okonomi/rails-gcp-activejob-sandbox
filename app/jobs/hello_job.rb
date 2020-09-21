class HelloJob < ApplicationJob
  def perform(name)
    p "Hello, #{name}!"
  end
end
