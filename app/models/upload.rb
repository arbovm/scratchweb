

class Upload
  
  attr_accessor :id, :file, :title, :progress
  
  def self.find id
    TransientDb.store[:uploads][id]
  end
  
  def self.create
    upload = self.new
    upload.id = TransientDb.create_id_for(:uploads)
    TransientDb.store[:uploads][upload.id] = upload
    upload
  end
  
  def to_json
    '{"_id":"'+id+'","file":"'+ (file ? file.path : "")+'","title":"'+ (title ? title : "")+'"}'
  end

end