class Admin::AlbumsController < Admin::BaseController
  before_action :set_album, except: [:index, :new, :create]

  def index
    @albums = Album.all
  end

  def show; end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)
    if @album.save
      redirect_to admin_albums_path, notice: 'Album creado exitosamente.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @album.update(album_params)
      redirect_to admin_albums_path, notice: 'Album creado exitosamente.'
    else
      render :new
    end
  end

  def sync
    @album.parse_imgur
    @album.save
    redirect_to admin_albums_path, notice: 'Sync performed!'
  end

  def toggle_publish
    if @album.update(published: !@album.published)
      redirect_to admin_albums_path, notice: 'Record updated'
    else
      redirect_to admin_albums_path, alert: "Error while updating record #{@album.id}"
    end
  end

  protected

  def set_album
    @album = Album.find(params[:id] || params[:album_id])
  end

  def album_params
    params.require(:album).permit(:title, :imgur_url, :video_collection)
  end
end