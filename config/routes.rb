Codegears::Application.routes.draw do
  root :to => "platform#index"

  resources :apps, :only => [:create, :show]
end
