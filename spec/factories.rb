FactoryGirl.define do
  factory :user do
    email "foo@example.com"
    password "secret"    
  end
  
  factory :article do
    name "something"
    content "secret content"
    author_name "Superman"    
  end
end