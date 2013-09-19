class ApplicationController < ActionController::Base
  # before_filter :set_headers
  # before_filter :cors_preflight_check
  # after_filter :cors_set_access_control_headers

  protect_from_forgery
  
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authorize
  
  delegate :allow?, to: :current_permission
  helper_method :allow?
  
  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?
  
  # after_filter :set_csrf_cookie

  # def set_csrf_cookie
  #   if protect_against_forgery?
  #     cookies['XSRF-TOKEN'] = form_authenticity_token
  #   end
  # end


# protected

#   def verified_request?
#     super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
#   end

private


  # def set_headers
  #   # headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Expose-Headers'] = 'ETag'
  #   headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
  #   headers['Access-Control-Allow-Headers'] = '*,X-Requested-With, X-Prototype-Version,Content-Type,If-Modified-Since,If-None-Match'
  #   headers['Access-Control-Max-Age'] = '86400'
  # end

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PATCH, PUT'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    # Rails.logger.debug "===============> #{request.method.inspect}"
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PATCH, PUT'
      headers['Access-Control-Allow-Headers'] = 'Content-Type' # 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end
  
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
