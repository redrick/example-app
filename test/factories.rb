require 'factory_girl'

FactoryGirl.define do

  sequence(:email, "a") do |n| 
    "foo#{n}@example.com"
  end

  factory :user do |u|
    u.password "secret"    
    u.password_confirmation "secret"
    u.email {|a| "foo#{a}@example.com"}
  end
  
  factory :article do
    name "something"
    content "secret content"
    author_name "Superman"    
  end
end