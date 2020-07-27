Rails.application.routes.draw do
  get 'welcome/index'
  root to: "welcome#index"
  devise_for :users
  resources :premiums
  resources :subscriptions
	  # collection do
	  #     get :manage_subscription , as: :manage_subscription
	  # end
	# end
  get '/manage_subscription', to: 'subscriptions#manage_subscription', as: :manage_subscription
  get '/unsubscribe', to: 'subscriptions#unsubscribe_plan', as: :unsubscribe

end
