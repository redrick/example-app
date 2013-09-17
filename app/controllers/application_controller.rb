class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authorize
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
  
  delegate :allow?, to: :current_permission
  helper_method :allow?
  
  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?


  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

private
  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def current_permission
    @current_permission ||= Permissions.permission_for(current_user)
  end
  
  def current_resource
    nil
  end

  def authorize
    if current_permission.allow?(params[:controller], params[:action], current_resource)
      current_permission.permit_params! params
    else 
      redirect_to root_path, alert: "Not authorized"
    end
  end
end
