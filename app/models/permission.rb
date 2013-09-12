class Permission < Struct.new(:user)
  
  def allow?(controller, action)
    controller == 'articles' && action == 'index'
  end

end