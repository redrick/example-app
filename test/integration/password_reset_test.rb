require 'minitest_helper'

describe "PasswordResets test" do

  describe "#functionality" do

    
    before(:each) do 
      log_out
    end

    it "emails user when requesting password reset" do
      user = FactoryGirl.create(:user)
      visit login_path
      click_link "password"
      fill_in "Email", with: user.email
      click_button "Reset Password"
      current_path.must_equal(root_path)
      page.must_have_content("Email sent")
      ActionMailer::Base.deliveries.last.to.must_include(user.email)
    end
    
    it "does not email invalid user when requesting password reset" do
      visit login_path
      click_link "password"
      fill_in "Email", :with => "nobody@example.com"
      click_button "Reset Password"
      current_path.must_equal(root_path)
      page.must_have_content("Email sent")
      ActionMailer::Base.deliveries.last.must_equal nil
    end

    it "updates the user password when confirmation matches" do
      user = FactoryGirl.create(:user, :password_reset_token => "something_else", :password_reset_sent_at => Time.now)
      visit edit_password_reset_path(user.password_reset_token)
      fill_in "Password", :with => "foobar"
      click_button "Update Password"
      page.must_have_content("Form is invalid")
      page.must_have_content("Password confirmation doesn't match Password")
      fill_in "Password", :with => "foobar"
      fill_in "Password confirmation", :with => "foobar"
      click_button "Update Password"
      page.must_have_content("Password has been reset!")
    end

    it "reports when password token has expired" do
      user = FactoryGirl.create(:user, :password_reset_token => "something", :password_reset_sent_at => 5.hours.ago)
      visit edit_password_reset_path(user.password_reset_token)
      fill_in "Password", :with => "foobar"
      fill_in "Password confirmation", :with => "foobar"
      click_button "Update Password"
      page.must_have_content("Password reset has expired")
    end

    it "raises record not found when password token is invalid" do
      lambda {
        visit edit_password_reset_path("invalid")
      }.must_raise(ActiveRecord::RecordNotFound)
    end

  end

end
