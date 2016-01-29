class Photo < ActiveRecord::Base

  IMAGE_THUMB = '125x125'
  IMAGE_MEDIUM = '600x800'
  IMAGE_LARGE = '1024x1200'  
  
  #attr_accessor :medium_filename, :original_filename, :small_filename, :large_filename, :default_instance
  
  belongs_to :location
  has_many :instances, dependent: :destroy 
  has_many :catalogs, through: :instances 


  before_save :geocode

  reverse_geocoded_by :latitude, :longitude

  scope :year, ->(year) {
    where(date_taken: Date.new(year, 1, 1)..Date.new(year, 12, 31))
  }

  scope :country, ->(country) {
    joins(:location).where('locations.country = ?', country)
  }
  
  def self.album(alb)
    
    if not alb.start.blank?
      p_start = get_predicate('date_taken', alb.start, :gt) 
      exp = p_start
    end
    
    if not alb.end.blank? 
      p_end = get_predicate('date_taken', alb.end, :lt) 
      if not exp.blank?
        exp = exp&p_end
      else
        exp= p_end
      end
    end
    
    if not alb.make.blank?
      p_make = get_predicate('make', alb.make, :eq) 
      if not exp.blank?
        exp = exp&p_make
      else
        exp = p_make
      end
    end
    
    if not alb.model.blank?
      p_model = get_predicate('model', alb.model, :eq) 
      if not exp.blank?
        exp = exp&p_model
      else
        exp = p_model
      end
    end

    location_stub = Squeel::Nodes::Stub.new(:location)

    if not alb.country.blank?
      p_country = get_predicate(:country, alb.country, :eq) 
      k_country = Squeel::Nodes::KeyPath.new([location_stub, p_country])
      if not exp.blank?
        exp = exp&k_country
      else
        exp = k_country
      end
    end



    if not alb.city.blank?
      p_city = get_predicate('city', alb.city, :eq) 
      k_city = Squeel::Nodes::KeyPath.new([location_stub, p_city])
      if not exp.blank?
        exp = exp&k_city
      else
        exp = k_city
      end
    end
    
    
    if not alb.photo_ids.blank?
      p_photo_ids = get_predicate('id', alb.photo_ids, :in) 
      if not exp.blank?
        exp = exp|p_photo_ids
      else
        exp = p_photo_ids
      end
    end
    
    
    
    
    self.joins(:location).where(exp)
    
    
    
    
    
    
  end

  Photo.joins(Squeel::Nodes::Join.new(Squeel::Nodes::Stub.new(:location), :inner)).where{Squeel::Nodes::Predicate.new(Squeel::Nodes::Stub.new(:city), :eq, 'Paris')}.to_sql






  
  def query
    self.latitude.to_s + "," + self.longitude.to_s
  end

  def original_filename
    @original_filename = File.join(self.path, self.filename + self.file_extension)
    @original_filename
  end
    
  def small_filename
    @small_filename = File.join(self.file_thumb_path,self.filename + "_tm" + self.file_extension)
    @small_filename
  end
  
  def medium_filename
    @medium_filename = File.join(self.file_thumb_path,self.filename + "_md" + self.file_extension)
    @medium_filename
  end
  
  def large_filename
    @large_filename = File.join(self.file_thumb_path, self.filename + "_lg" + self.file_extension)
    @large_filename
  end
  
  def default_instance
    @default = Catalog.where(default: true).first  #"/Volumes/phototank/"
    @default.path
  end
  
  def populate_from_file path
    begin
      logger.debug 'before process_image path'
      process_image path
      logger.debug 'before get_exif path'
      get_exif path
      logger.debug 'before       process_thumb'
      process_thumbs path

      
    rescue Exception => e 
      logger.debug e
      return false
    end
    self
  end  


  def self.get_predicate(col, value, predicate)
    Squeel::Nodes::Predicate.new(Squeel::Nodes::Stub.new(col), predicate, value)
  end  
  
  private
  

  
  
    def get_exif path
      exif = MiniExiftool.new(path, opts={:numerical=>true})

      if not exif.datetimeoriginal.blank?
        self.date_taken = exif.datetimeoriginal 
      else
        self.date_taken = File.ctime(path)
      end
      self.longitude = exif.gpslongitude
      self.latitude = exif.gpslatitude
      self.make = exif.make
      self.model = exif.model
      
      
    end
  
    def process_image path
      logger.debug path
      begin
        @image = MiniMagick::Image.open(path)
      rescue Exception => e 
        logger.debug e.msg
        logger.debug "File is not a JPEG"
        raise "File is not a JPEG"
          
      else
        self.filename = @image.signature
        self.original_width = @image.width
        self.original_height = @image.height
        self.file_size = @image.size
        self.file_extension = ".jpg"
      end
  
    end
  
  
    def process_thumbs original_path
      if not @image.blank? 
        date_path = File.join(self.date_taken.strftime("%Y"), self.date_taken.strftime("%m"), self.date_taken.strftime("%d"))
        sub_path = File.join(self.default_instance, 'phototank', 'thumbs', date_path).to_s
        FileUtils.mkdir_p sub_path
        
        file_path = File.join(sub_path, self.filename + "_lg"+ self.file_extension).to_s
        if not File.exists?(file_path)
          @image.resize IMAGE_LARGE
          @image.write file_path
        end
        
        file_path = File.join(sub_path, self.filename + "_md"+ self.file_extension).to_s
        if not File.exists?(file_path)
          @image.resize IMAGE_MEDIUM
          @image.write file_path
        end

        file_path = File.join(sub_path, self.filename + "_tm"+ self.file_extension).to_s
        if not File.exists?(file_path)
          @image.resize IMAGE_THUMB
          @image.write file_path
        end
        
        self.file_thumb_path = File.join('phototank', 'thumbs', date_path)
                
        sub_path = File.join(self.default_instance, 'phototank', 'originals', date_path).to_s
        file_path = File.join(sub_path, self.filename + self.file_extension).to_s
        FileUtils.mkdir_p sub_path
        File.rename original_path, file_path
        
        self.path = File.join('phototank', 'originals', date_path)

        
      end
      
    end


    def geocode

      
        
      
      
      
      if not self.latitude.blank? || self.longitude.blank?
        similar_locations = self.nearbys(1).where.not(location: nil)
        if similar_locations.blank?
          geo_location = Geocoder.search(self.query).first
          if not geo_location.nil?
            if geo_location.data["error"].blank?
              new_location = Location.new
              new_location.country = geo_location.country
              new_location.city = geo_location.city
              new_location.suburb = geo_location.suburb
              new_location.postcode = geo_location.postal_code
              new_location.address = geo_location.address
              new_location.state = geo_location.state
              new_location.longitude = geo_location.longitude
              new_location.latitude = geo_location.latitude
              new_location.save
              self.location = new_location
            end
          else
            self.location = nil  
          end
        else
          self.location = similar_locations.first.location
        end
      end    
    end 
end