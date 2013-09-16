require "minitest_helper"

describe "UserMailer test" do

  describe "password_reset" do
  
    let(:user) { FactoryGirl.create(:user, password_reset_token: "Anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "sends user password reset url" do
      mail.subject.must_equal("Password Reset")
      mail.to.must_equal(user.email)
      mail.from.must_equal(["from@example.com"])
      mail.body.encoded.must_match(edit_password_reset_path(user.password_reset_token))
    end

  end

end
