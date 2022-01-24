class AlbumsController < ApplicationController
  before_action :set_album, except: [:index]

  def index
    @albums = Album.published
  end

  def show; end

  protected

  def set_album
    @album = Album.published.find(params[:id] || params[:album_id])
  end
end
