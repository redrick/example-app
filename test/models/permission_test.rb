require 'minitest_helper'

describe "Permissions test" do

  describe "as guest" do
    
    it "should allow guest to work with articles like this" do
      Permissions.permission_for(nil).allow?(:articles, :index).must_equal true
      Permissions.permission_for(nil).allow?(:articles, :show).must_equal true

      Permissions.permission_for(nil).allow?(:articles, :new).wont_equal true
      Permissions.permission_for(nil).allow?(:articles, :create).wont_equal true
      Permissions.permission_for(nil).allow?(:articles, :edit).wont_equal true
      Permissions.permission_for(nil).allow?(:articles, :update).wont_equal true
      Permissions.permission_for(nil).allow?(:articles, :destroy).wont_equal true
    end


    it "should allow guest to work with session like this" do
      Permissions.permission_for(nil).allow?(:sessions, :new).must_equal true
      Permissions.permission_for(nil).allow?(:sessions, :create).must_equal true
      Permissions.permission_for(nil).allow?(:sessions, :destroy).must_equal true
    end

    it "should allow guest to work with users like this" do
      Permissions.permission_for(nil).allow?(:users, :new).must_equal true
      Permissions.permission_for(nil).allow?(:users, :create).must_equal true
  
      Permissions.permission_for(nil).allow?(:users, :edit).wont_equal true
      Permissions.permission_for(nil).allow?(:users, :update).wont_equal true
    end


    it "should allow guest to work with attributes like this" do
      Permissions.permission_for(nil).allow_param?(:article, :name).wont_equal true
      Permissions.permission_for(nil).allow_param?(:article, :sticky).wont_equal true
    end
  end
  
  describe "as admin" do
    
    it "should let admin do anything on page" do
      Permissions.permission_for(FactoryGirl.build(:user, admin: true)).allow?(:anything, :here).must_equal true
    end

    it "should let admin do anything with params" do
      Permissions.permission_for(FactoryGirl.build(:user, admin: true)).allow_param?(:anything, :here).must_equal true
    end

  end
  
  describe "as member" do
    let(:user) { FactoryGirl.create(:user, admin: false) }
    let(:user_article) { FactoryGirl.create(:article, user: user) }
    let(:other_article) { FactoryGirl.create(:article) }

    it "should allow member to work with articles like this" do
      Permissions.permission_for(user).allow?(:articles, :index).must_equal true
      Permissions.permission_for(user).allow?(:articles, :show).must_equal true
      Permissions.permission_for(user).allow?(:articles, :new).must_equal true
      Permissions.permission_for(user).allow?(:articles, :create).must_equal true

      Permissions.permission_for(user).allow?(:articles, :edit).wont_equal true
      Permissions.permission_for(user).allow?(:articles, :update).wont_equal true
      Permissions.permission_for(user).allow?(:articles, :edit, other_article).wont_equal true
      Permissions.permission_for(user).allow?(:articles, :update, other_article).wont_equal true
      Permissions.permission_for(user).allow?(:articles, :destroy).wont_equal true

      Permissions.permission_for(user).allow?(:articles, :edit, user_article).must_equal true
      Permissions.permission_for(user).allow?(:articles, :update, user_article).must_equal true
    end

    it "should allow member to work with attributes like this" do
      Permissions.permission_for(user).allow_param?(:article, :name).must_equal true
      Permissions.permission_for(user).allow_param?(:article, :sticky).wont_equal true
    end
  end
end