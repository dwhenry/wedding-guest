class Detail < ActiveRecord::Base
  PAGES = ['Home', 'About Us', 'Ceremony & Reception',
    'Timetable', 'Directions', 'The Day After']
  FORMATS = {
    'H1' => 'Main Header',
    'H2' => 'Sub Header'
  }

  extend Fields
  prettify_string :page_name
  mount_uploader :image, BrideGroomUploader

  attr_accessible :page_name, :order, :text, :wedding_id, :image_cache, :formatting_class

  belongs_to :wedding

  validates_uniqueness_of :order, scope: [:wedding_id, :page_name]
  validates_presence_of :page_name, :wedding_id, :text, :order

  before_validation :ensure_ordered

  scope :for, ->(page_name) { where(page_name: page_name) }

  def ensure_ordered
    self.order ||= (wedding.page_details.for(self.page_name).maximum(:order) || 0) + 1
  end

  def formatting
    FORMATS[self.formatting_class]
  end
end
