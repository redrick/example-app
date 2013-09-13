require 'spec_helper'

describe "Articles" do
  it "edits own topic as member" do
    log_in admin: false
    article = FactoryGirl.create(:article, user: current_user)
    visit edit_article_path(article)
    page.should_not have_content("Not authorized")
  end

  it "cannot create sticky topic as member" do
    user = FactoryGirl.create(:user, admin: false, password: "secret")
    post sessions_path, email: user.email, password: "secret"
    post articles_path, article: {name: "Sticky Article?", sticky: "1"}
    article = Article.last
    article.name.should eq("Sticky Article?")
    article.should_not be_sticky
  end
end