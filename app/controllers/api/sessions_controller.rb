class Api::SessionsController < Api::BaseController
  def create
    #signin
    user = User.find_by_discord_uid(params[:uid])
    render json: user
  end

  def destroy
    #signout
  end
end
