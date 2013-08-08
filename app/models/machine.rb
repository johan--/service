class Machine < ActiveRecord::Base
  attr_accessible :manufacturer_id, :machine_owner_id, :machine_number, :machine_type, :delivery_date, :waranty_period, :display_name
  belongs_to :manufacturer
  belongs_to :machine_owner
  has_many :events
#validari
validates :display_name, :presence => true,
  				   :length => { :within => 3..255 },
  				   :uniqueness => true
validates :machine_number, :presence => true,
  				      :length => { :within => 3..255 }

validates :machine_type, :presence => true,
				      :length => { :within => 3..255 }

validates :delivery_date, :presence => true,
				      :length => { :within => 3..255 }

validates :waranty_period, :presence => true,
				      :length => { :within => 3..255 }

end
