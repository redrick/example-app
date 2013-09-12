require "spec_helper"

RSpec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

describe Permission do
  describe "as guest" do
    subject { Permission.new(nil) }
    
    it { should allow(:articles, :index) }
    it { should allow(:articles, :show) }
    it { should_not allow(:articles, :new) }
    it { should_not allow(:articles, :create) }
    it { should_not allow(:articles, :edit) }
    it { should_not allow(:articles, :update) }
    it { should_not allow(:articles, :destroy) }

    it { should allow(:sessions, :new) }
    it { should allow(:sessions, :create) }
    it { should allow(:sessions, :destroy) }

    it { should allow(:users, :new) }
    it { should allow(:users, :create) }
    it { should_not allow(:users, :edit) }
    it { should_not allow(:users, :update) }
  end
  
  describe "as admin" do
    subject { Permission.new(FactoryGirl.build(:user, admin: true)) }
    
    it { should allow(:anything, :here) }
  end
  
  describe "as member" do
    let(:user) { FactoryGirl.create(:user, admin: false) }
    let(:user_article) { FactoryGirl.build(:article, user: user) }
    let(:other_article) { FactoryGirl.build(:article) }
    subject { Permission.new(user) }

    it { should allow(:articles, :index) }
    it { should allow(:articles, :show) }
    it { should allow(:articles, :new) }
    it { should allow(:articles, :create) }
    it { should_not allow(:articles, :edit) }
    it { should_not allow(:articles, :update) }
    it { should_not allow(:articles, :edit, other_article) }
    it { should_not allow(:articles, :update, other_article) }
    it { should allow(:articles, :edit, user_article) }
    it { should allow(:articles, :update, user_article) }
    it { should_not allow(:articles, :destroy) }
  end
end