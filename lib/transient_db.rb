class TransientDb
  
  @store = {}
  @store.default = {}
  
  def self.create_id_for bucket
    id = new_hex_id 
    id = new_hex_id while store[bucket].has_key?(id)
    id
  end
  
  def self.new_hex_id
    ("%05X" % rand(1048575)).downcase
  end
  
  def self.store
    @store
  end
  
end