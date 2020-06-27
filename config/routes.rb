Rails.application.routes.draw do

  scope module: 'com' do
    controller :common do
      get :infos
      get :cache_list
      get :enum_list
      get :qrcode
      get :test_raise
      match :deploy, via: [:get, :post]
    end
  end

  scope 'rails/active_storage', module: :com do
    resources :direct_uploads, only: [:create]
  end

  scope :rails, module: 'com', as: :rails_ext do
    resources :videos, only: [:show] do
      member do
        put :transfer
      end
    end
    resources :audios, only: [:show] do
      member do
        put :transfer
      end
    end
    resources :pdfs, only: [:show] do
      member do
        get :png
        get :jpg
      end
    end
  end

  scope :panel, module: 'com/panel', as: :panel do
    resources :infos
    resources :cache_lists
    resources :attachments, only: [:index, :destroy] do
      collection do
        get :garbled
      end
      member do
        delete :delete
      end
    end
    resources :blobs, only: [:index, :show, :new, :create, :destroy] do
      collection do
        get :unattached
      end
    end
    resources :blob_defaults
  end

end
