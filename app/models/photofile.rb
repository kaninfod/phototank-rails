class Photofile < ActiveRecord::Base
  attr_accessor :data, :url, :datehash, :phash
  validates :path, presence: true
  before_create :import_file
  before_update :update_file
  before_destroy :delete_file

  PATH = Rails.configuration.x.phototank["filestorepath"]

  def update_file
    begin
      FileUtils.cp self.data, self.path
      self.touch
    rescue Exception => e
      byebug
    end
  end

  def import_file
    begin
      path = File.join(PATH, self.datehash[:year].to_s, self.datehash[:month].to_s,self.datehash[:day].to_s)
      FileUtils.mkdir_p File.join(path)
      #TODO change extension. Should come from mime
      filename = "#{datehash[:datestring]}_#{datehash[:size]}_#{datehash[:unique]}.jpg"
      filepath = File.join(path, filename)
      FileUtils.cp self.path, filepath
      self.path = filepath
      self.size = datehash[:size]

    rescue Exception => e
      byebug
    end
  end

  def delete_file
    FileUtils.rm self.path if File.exists? self.path
  end

  def get_phash
      phash = Phashion::Image.new(self.path)
      phash = phash.fingerprint
      return phash
  end

  def rotate(degrees)
    begin
      MiniMagick::Tool::Convert.new do |convert|
        convert << self.path
        convert << "-rotate" << degrees
        convert << self.path
      end
    rescue Exception
      Rails.logger.warn "Photofile #{self.id} was not rotated!"
      return false
    end
  end
  private


end
