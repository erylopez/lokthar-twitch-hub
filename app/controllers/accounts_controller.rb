class AccountsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def edit; end

  def birthday
    day = params["birth_date"].split("-").first
    month = params["birth_date"].split("-").last

    current_user.update(points: current_user.points + 500) unless (current_user.birth_month.present? || current_user.birth_day.present?)

    if current_user.update(birth_day: day, birth_month: month)
      render json: {msg: "Guardado exitosamente!"}, status: :ok
    else
      render json: {msg: current_user.errors.full_messages }, status: 500
    end
  end

  def country
    current_user.update(points: current_user.points + 500) unless current_user.country.present?

    if current_user.update(country: params[:country])
      render json: {msg: 'Guardado exitosamente!'}, status: :ok
    else
      render json: {msg: current_user.errors.full_messages }, status: 500
    end
  end
end
