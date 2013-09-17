module Api
  class ProductsController < ApplicationController
    respond_to :json

    def index
      respond_with Product.all
    end

    def show
      respond_with Product.find(params[:id])
    end

    def create
      respond_with Product.create(product_params)
    end

    def update
      respond_with Product.update(params[:id], product_params)
    end

    def destroy
      respond_with Product.destroy(params[:id])
    end

    private
      # Only allow a trusted parameter "white list" through.
      def product_params
        params.require(:product).permit(:id, :name, :description, :user_id, :on_stock)
      end
  end
end
