class Streamers::ModsController < Streamers::BaseController
  def create
    user = User.where('lower(name) = ?', params[:username].downcase).first
    mod = StreamMod.where(user: user, streamer: current_user.streamer_record).first_or_create

    if mod.valid?
      flash[:notice] = "Se agrego un moderador!"
    else
      flash[:alert] = "No se encontro el usuario. Recuerda que debe coincidir con su usuario en Twitch."
    end

    render json: {msg: 'mod added'}
  end

  def destroy
    mod = StreamMod.find(params[:id])
    mod.destroy
    flash[:notice] = "Moderador eliminado."

    render json: {msg: 'mod removed'}
  end
end
