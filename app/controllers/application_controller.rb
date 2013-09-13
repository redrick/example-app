class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authorize
  
  delegate :allow?, to: :current_permission
  helper_method :allow?

private
  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def current_permission
    @current_permission ||= Permission.new(current_user) 
  end
  
  def current_resource
    nil
  end

  def authorize
    if !current_permission.allow?(params[:controller], params[:action], current_resource)
      redirect_to root_path, alert: "Not authorized"
    end
  end
end
