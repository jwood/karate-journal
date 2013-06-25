KarateJournal::Application.routes.draw do
  resources :entries do
    collection do
      get :search
    end
  end

  root 'entries#index'
end
