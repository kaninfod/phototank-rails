class AlbumsController < ApplicationController
  before_action :authenticate_user!


  def show
    viewmode

    @bucket = session[:bucket]
    @album = Album.find(params[:id])

    #Get photos
    @photos = @album.photos.paginate(:page => params[:page], :per_page => 24)

    #If this was requested from an ajax call it should be rendered with slim view
    if request.xhr?
      render :partial=>"photos/view/grid"
    end
  end

  def index
    order = params[:order] unless not params.has_key?(:order)
    query = "%#{params[:q]}%"
    query ||="%"
    @albums = Album.order(order).where{name.matches(query)}.paginate(:page => params[:page], :per_page => 20)
  end

  def edit
    @album = Album.find(params[:id])
    prep_form
  end

  def update
    @album = Album.find(params[:id])
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /photos/new
  def new
    @album = Album.new
    prep_form
  end

  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def select
    if request.post?
      if not params[:optionsRadios].blank?
        album = Album.find(params[:optionsRadios].to_i)
        a = (album.photo_ids + session[:bucket]).uniq{|x| x}
        album.photo_ids = a
        if album.save
          redirect_to '/albums'
        end
      end
    else
      @albums = Album.all.page params[:page]
    end


  end

# def show_stat
#
# end

  private

    def album_params
      params.require(:album).permit(:start, :end, :name, :make, :model, :country, :city, :photo_ids, :album_type)
    end

    def prep_form
      @countries = Location.distinct_countries
      @cities = Location.distinct_cities
      @makes = Photo.distinct_makes
      @models = Photo.distinct_models
      @bucket = session[:bucket]
    end

    def viewmode
      if params.has_key?(:viewmode)
        @view = params[:viewmode]
      else
        @view = 'grid'
      end
    end

end
