Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/game", to: "games#new"
  post "/score", to: "games#score"

  # get "/score", to: "games#score"
end
