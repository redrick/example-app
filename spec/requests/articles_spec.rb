require 'spec_helper'

describe "Articles" do
  it "lists articles as guest" do
    FactoryGirl.create(:article, name: "Hello")
    FactoryGirl.create(:article, name: "World")
    visit articles_path
    page.should have_content("Hello")
    page.should have_content("World")
  end

  it "creates article as member" do
    log_in admin: false
    visit articles_path
    click_on "Create new article"
    fill_in "Name", with: "Foobar"
    click_on "Create Article"
    page.should have_content("Article has been created.")
    page.should have_content("Foobar")
  end

  it "updates article as admin" do
    FactoryGirl.create(:article, name: "Old Name")
    log_in admin: true
    visit articles_path
    page.should have_content("Old Name")
    click_on "Edit"
    fill_in "Name", with: "New Name"
    click_on "Update Article"
    page.should have_content("Article has been updated.")
    page.should have_content("New Name")
    page.should_not have_content("Old Name")
  end
  
  it "Deletes article as admin" do
    FactoryGirl.create(:article, name: "Oops")
    log_in admin: true
    visit articles_path
    page.should have_content("Oops")
    click_on "Delete"
    page.should have_content("Article removed!")
    page.should_not have_content("Oops")
  end
  
  it "cannot edit article as guest" do
    article = FactoryGirl.create(:article)
    visit edit_article_path(article)
    page.should have_content("Not authorized")
  end

  it "edits own article as member" do
    log_in admin: false
    article = FactoryGirl.create(:article, user: current_user)
    visit edit_article_path(article)
    page.should_not have_content("Not authorized")
  end

  it "cannot create sticky article as member" do
    user = FactoryGirl.build(:user, admin: false, password: "secret")
    post sessions_path, email: user.email, password: "secret"
    post articles_path, article: {name: "Sticky Article?", sticky: "1"}
    article = Article.last
    article.name.should eq("Sticky Article?")
    article.should_not be_sticky
  end
end