class ArticlesController < ApplicationController
  
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(params[:article])
    if @article.save
      redirect_to @article, notice: "Article has been created."
    else
      render :new
    end
  end
  
  def update
    @article = Article.find(params[:id])
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
end
