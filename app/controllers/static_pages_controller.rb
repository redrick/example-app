class StaticPagesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "admin"
  
  def index
  end
end
