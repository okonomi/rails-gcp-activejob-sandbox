Rails.application.routes.draw do
  get '/hello/:name' => 'hello#index'
end
