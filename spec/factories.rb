require 'factory_girl'

FactoryGirl.define do
  sequence :email, "a" do |n| 
    "foo#{n}@example.com"
  end

  factory :user do
    password "secret"    
    password_confirmation "secret"    
    email {FactoryGirl.generate :email}
    # after :build do |u|
    #   u.email = FactoryGirl.generate(:email)
    # end
  end
  
  factory :article do
    name "something"
    content "secret content"
    author_name "Superman"    
  end
end