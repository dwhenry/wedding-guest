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
    'large'   => [250, 250],
    'larger'   => [300, 300],
    'largest'   => [350, 350]
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
    Detail.transaction do
      if current_position == position
        return # do nothing
      elsif current_position < position
        # move down
        update_attribute(order: -1)
        details = wedding.page_details.for(raw_page_name)
        to_be_changed = .select {|d| (current_positon..position).include?(d.order) }.sort_by(&:order)
        to_be_changed.each do |to_change|
          to_change.update_attributes(order: to_change.order - 1)
        end
        update_attribute(order: position)
      else
        # move up
        update_attribute(order: -1)
        details = wedding.page_details.for(raw_page_name)
        to_be_changed = .select {|d| (position..current_positon).include?(d.order) }.sort_by(&:order).reverse
        to_be_changed.each do |to_change|
          to_change.update_attributes(order: to_change.order + 1)
        end
        update_attribute(order: position)
      end
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
