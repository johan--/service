class Alarm < ActiveRecord::Base
  attr_accessible :number, :text, :machine_group_id
  belongs_to :machine_group
  has_and_belongs_to_many :service_events

  validates :number, :presence => true, :uniqueness => {:scope => :machine_group_id}
  
  scope :search, lambda { |number, machine| where("number LIKE ? AND machine_group_id = ?", "#{number}", "#{machine}".to_i) }

  def self.import(file, group)
	  if file && file.original_filename.split(".").pop == "csv"	
	  	CSV.foreach(file.path, headers: :true) do |row|
	  		alarm = find_by_id(row["id"]) || new
	  		alarm.attributes = row.to_hash.slice(*accessible_attributes).merge!(:machine_group_id => group)
	  		alarm.save if alarm.valid?
	  	end
	  	return true
	  else
	  	return false
	  end

	rescue
		return false
  end
end