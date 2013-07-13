class Detail < ActiveRecord::Base
  PAGES = ['Home', 'About Us', 'Ceremony & Reception',
    'Timetable', 'Directions', 'The Day After', 'RSVP Online', 'Gift List', 'Where To Stay']
  FORMATS = {
    'H1' => 'Main Header',
    'H2' => 'Sub Header',
    'ADDRESS' => 'Address',
    'TIMETABLE' => 'Timetable'
  }
  IMAGE_SIZES = {
    'small'   => [150, 150],
    'medium'  => [200, 200],
    'large'   => [250, 250]
  }

  extend Fields
  prettify_string :page_name
  mount_uploader :image, DetailsUploader

  attr_accessible :page_name, :order, :text, :wedding_id, :image,
    :image_cache, :formatting_class, :image_size

  belongs_to :wedding

  validates_uniqueness_of :order, scope: [:wedding_id, :page_name]
  validates_presence_of :page_name, :wedding_id, :text, :order
  validates_presence_of :image_size, if: ->(d) { d.image? }

  before_validation :ensure_ordered

  scope :for, ->(page_name) { where(page_name: page_name) }

  def ensure_ordered
    self.order = nil if changed.include?('page_name')
    self.order ||= (wedding.page_details.for(self.raw_page_name).maximum(:order) || 0) + 1
  end

  def formatting
    FORMATS[self.formatting_class]
  end

  def move_to(position)
    move_to = wedding.page_details.for(raw_page_name)[position]
    move_to_position = move_to.order
    current_position = self.order

    Detail.transaction do
      move_to.update_attributes(order: -1)
      update_attributes(order: position)
      move_to.update_attributes(order: current_position)
    end
  end

  def sized_url
    image.send(image_size).url
  end

  def each_text_element(&block)
    text.split(/[\r\n]+/).each do |text|
      block.call(text)
    end
  end
end
