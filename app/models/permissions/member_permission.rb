module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :users, [:edit, :update]
      allow :articles, [:new, :create, :index, :show]
      allow :sessions, [:new, :create, :destroy]
      allow :articles, [:edit, :update] do |article|
        article.user_id == user.id
      end
      allow_param :article, [:name]
    end
  end
end