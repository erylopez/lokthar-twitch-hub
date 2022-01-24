class Api::RecruitmentsController < Api::BaseController

  def create
    activity     = params[:hrsPerDay].select{|k,v| k if v}.keys.first
    hours_ranges = params[:hrRange].select{|k,v| k if v}.keys.join(", ")
    role         = params[:role].select{|k,v| k if v}.keys.first
    playstyle    = params[:playstyle].select{|k,v| k if v}.keys.first
    nick         = params[:userNick]
    discord      = params[:discord]
    referral     = params[:referral]

    
  end

end