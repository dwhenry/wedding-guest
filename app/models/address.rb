class Address < ActiveRecord::Base
  belongs_to :wedding

  validates_presence_of :address_type
  validates_presence_of :name
end
