module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow "api/products", [:new, :create, :edit, :update, :destroy, :delete, :index, :show]
      allow "api/articles", [:new, :create, :edit, :update, :destroy, :delete, :index, :show]
      allow :products, [:new, :create, :edit, :update, :destroy, :delete, :index, :show]
      allow :password_resets, [:new, :create, :edit, :update, :destroy, :delete]
      allow :static_pages, []
      allow :users, [:new, :create]
      allow :sessions, [:new, :create, :destroy]
      allow :articles, [:index, :show]
    end
  end
end