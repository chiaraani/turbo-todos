# frozen_string_literal: true

Rails.application.routes.draw do
  root 'todos#index'

  resources :todos, except: :show
end
