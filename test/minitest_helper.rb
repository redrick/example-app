ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)

require "rubygems"
require "minitest/autorun"
require "capybara/rails"
require 'rails/test_help'
require "active_support/testing/setup_and_teardown"

class MyTests < MiniTest::Spec
  # include ActiveSupport::Testing::SetupAndTeardown
  # include ActionView::TestCase::Behavior

  # empty mail deliveries array
  ActionMailer::Base.deliveries = []

  include Rails.application.routes.url_helpers
  include Capybara::DSL

  def log_in(attributes = {})
    @current_user = FactoryGirl.create(:user, attributes)
    visit login_path
    fill_in "Email", with: @current_user.email
    fill_in "Password", with: @current_user.password
    click_button "Log In"
    page.must_have_content "Logged in!"
  end

  def log_out
    visit logout_path
    page.must_have_content "Logged out!"
  end

  def current_user
    @current_user
  end

  def require_js
    Capybara.current_driver = :webkit
  end

  def teardown
    super
    Capybara.current_driver = nil
  end

  register_spec_type(/test$/, self)
end

Rails.application.routes.default_url_options[:host] = 'localhost:3003' 

Turn.config.format = :progress