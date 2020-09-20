class SampleJob < ApplicationJob
  def perform(num)
    p "sample job #{num} executed!"
  end
end
