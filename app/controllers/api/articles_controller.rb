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
      def article_params
        params.require(:article).permit(:id, :name, :content, :user_id, :author_name, :sticky)
      end    

    # users_controller.rb

    # =begin resource
    # description: Represents an user in the system.
    # =end

    # =begin action
    # method: GET
    # action: index
    # requires_authentication: no
    # response_formats: json
    # description: Return all users of the system.
    #
    # http_responses:
    #   - 200
    #   - 401
    #   - 403
    #
    # params:
    #   - name: page
    #     description: number of page in pagination
    #     required: false
    #     type: Integer
    #
    #   - name: limit
    #     description: number of elements by page in pagination
    #
    #   - name: name
    #     description: name filter
    # =end
  end
end
