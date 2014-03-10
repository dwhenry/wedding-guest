class Rsvp < ActiveRecord::Base
  attr_accessible :attendance, :dietary, :email, :linked, :message, :name, :wedding_id, :wedding, :bus_required, :evening

  belongs_to :wedding
  validates :wedding_id, presence: true
  validates :name, presence: true

  validate :validate_email

  scope :on_bus, where(bus_required: true)

  def validate_email
    unless email.present? && email =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
      errors[:email] << 'is not a valid email address'
    end
  end
end
