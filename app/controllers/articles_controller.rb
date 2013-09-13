class ArticlesController < ApplicationController
  
  def index
    @articles = Article.page(params[:page]).per_page(7)
  end

  def show
    @article = current_resource
  end

  def edit
    @article = current_resource
  end

  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(params[:article])
    @article.user = current_user
    if @article.save
      redirect_to @article, notice: "Article has been created."
    else
      render :new
    end
  end
  
  def update
    @article = current_resource
    if @article.update_attributes(params[:article])
      redirect_to @article, notice: "Article has been updated."
    else
      render "edit"
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.delete
    redirect_to root_url, notice: "Article removed!"
  end
  
private
  
  def current_resource
    @current_resource ||= Article.find(params[:id]) if params[:id]
  end
end
