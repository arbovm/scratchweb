

class Upload
  
  attr_accessor :id, :file, :filename, :progress
  
  def self.find id
    TransientDb.store[:uploads][id]
  end
  
  def self.create
    upload = self.new
    upload.id = TransientDb.create_id_for(:uploads)
    TransientDb.store[:uploads][upload.id] = upload
    upload
  end
  
  
end