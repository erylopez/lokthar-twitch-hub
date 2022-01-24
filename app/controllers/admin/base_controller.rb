class Admin::BaseController < ApplicationController
  before_action :check_admin

  protected

  def check_admin
    unless current_user && current_user.email == "matiasmoya@gmail.com"
      redirect_to root_path, alert: "Acceso denegado"
    end
  end
end