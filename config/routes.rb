Rails.application.routes.draw do
  get '/hello/:name' => 'hello#index'
  post '/worker' => 'hello#worker'
end
