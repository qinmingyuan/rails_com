Rails.application.routes.draw do

  scope :rails, as: 'rails', module: 'active_storage' do
    resources :attachments, only: [:destroy]
    resources :videos, only: [:index, :show]
  end

end
