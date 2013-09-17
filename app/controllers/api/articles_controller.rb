module Api
  class ArticlesController < ApplicationController
    respond_to :json

    def index
      respond_with Article.all
    end

    def show
      respond_with Article.find(params[:id])
    end

    def create
      respond_with Article.create(article_params)
    end

    def update
      respond_with Article.update(params[:id], article_params)
    end

    def destroy
      respond_with Article.destroy(params[:id])
    end

    private
      # Only allow a trusted parameter "white list" through.
      def article_params
        params.require(:article).permit(:id, :name, :description, :user_id, :on_stock)
      end
  end
end
