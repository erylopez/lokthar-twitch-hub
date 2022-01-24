class ApplicationController < ActionController::Base
  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, alert: 'Necesitas iniciar sesion para acceder a esa pagina.'
    end
  end

  def stored_location_for(resource_or_scope)
    session[:user_return_to] || super
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
