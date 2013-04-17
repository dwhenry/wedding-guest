class Detail < ActiveRecord::Base
  extend Fields
  prettify_string :detail_type
  mount_uploader :image, BrideGroomUploader

  DETAIL_TYPES = [
    HOME = 'home',
    ABOUT_BRIDE = 'about_the_bride',
    ABOUT_GROOM = 'about_the_groom',
    HOW_WE_MET = 'how_we_met'
  ]

  attr_accessible :detail_text, :detail_type, :image, :wedding_id

  belongs_to :wedding

  validates_uniqueness_of :detail_type, :scope => :wedding_id

  def self.types
    DETAIL_TYPES.sort.map do |detail_type|
      [
        detail_type.gsub(/_/, ' ').titlecase,
        detail_type
      ]
    end
  end
end
