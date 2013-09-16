require 'minitest_helper'

describe "Articles test" do

  describe "#article_editing" do
    
    before(:each) do 
      log_out
    end

    it "lists articles as guest" do
      FactoryGirl.create(:article, name: "Hello")
      FactoryGirl.create(:article, name: "World")
      visit articles_path
      page.must_have_content("Hello")
      page.must_have_content("World")
    end

    it "creates article as member" do
      log_in admin: false
      visit articles_path
      click_on "Create new article"
      fill_in "Name", with: "Foobar"
      click_on "Create Article"
      page.must_have_content("Article has been created.")
      page.must_have_content("Foobar")
    end

    it "updates article as admin" do
      FactoryGirl.create(:article, name: "Old Name")
      log_in admin: true
      visit articles_path
      page.must_have_content("Old Name")
      page.first(:link, "Edit").click
      fill_in "Name", with: "New Name"
      click_on "Update Article"
      page.must_have_content("Article has been updated.")
      page.must_have_content("New Name")
      page.wont_have_content("Old Name")
    end
    
    it "Deletes article as admin" do
      FactoryGirl.create(:article, name: "Oops")
      log_in admin: true
      visit articles_path
      page.must_have_content("Oops")
      # click_on "Delete"
      page.first(:link, "Delete").click
      page.must_have_content("Article removed!")
      page.wont_have_content("Oops")
    end
    
    it "cannot edit article as guest" do
      article = FactoryGirl.create(:article)
      visit edit_article_path(article)
      page.must_have_content("Not authorized")
    end

    it "edits own article as member" do
      log_in admin: false
      article = FactoryGirl.create(:article, user: current_user)
      visit edit_article_path(article)
      page.wont_have_content("Not authorized")
    end

    it "cannot create sticky article as member" do
      user = FactoryGirl.create(:user, admin: false, password: "secret")
      page.driver.post sessions_path, email: user.email, password: "secret"
      page.driver.post articles_path, article: {name: "Sticky Article?", sticky: "1"}
      article = Article.last
      article.name.must_equal("Sticky Article?")
      article.sticky?.wont_equal true
    end

  end

end