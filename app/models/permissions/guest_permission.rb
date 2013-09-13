module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :password_resets, [:new, :create, :edit, :update, :destroy, :delete]
      allow :static_pages, []
      allow :users, [:new, :create]
      allow :sessions, [:new, :create, :destroy]
      allow :articles, [:index, :show]
    end
  end
end