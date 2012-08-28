TestApp::Application.routes.draw do
  resources :products do
    post :create_only_name, :on => :collection
    get :new_only_name, :on => :collection
  end

  root :to => "products#index"
end
