require 'minitest_helper'

describe "User test" do

  describe "#send_password_reset" do
  
    before(:each) do 
      @user = FactoryGirl.build(:user)
    end

    it "generates a unique password_reset_token each time" do
      @user.send_password_reset
      last_token = @user.password_reset_token
      @user.send_password_reset
      @user.password_reset_token.wont_equal(last_token)
    end

    it "saves the time the password reset was sent" do
      @user.send_password_reset
      @user.reload.password_reset_sent_at.must_be_instance_of ActiveSupport::TimeWithZone
    end

    it "delivers email to user" do
      @user.send_password_reset
      ActionMailer::Base.deliveries.last.to.must_include(@user.email)
    end
  
  end

end