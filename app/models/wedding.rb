class Wedding < ActiveRecord::Base
  extend Fields
  formatted_date :on
  mount_uploader :image, BrideGroomUploader
  default_scope :order => 'weddings.name'

  has_many :guests
  has_many :addresses
  has_many :guest_lists, :order => 'created_at'
  has_many :gifts
  has_many :details

  validates_presence_of :name, :on, :bride, :groom, :bride_email, :groom_email
  validates_uniqueness_of :param_name
  after_create :create_guest_lists
  before_save :set_param_name

  def set_param_name
    self.param_name = name.downcase.gsub(/ /, '_')
  end

  def create_guest_lists
    all_guests = self.guest_lists.create!(:name => 'All', :description => 'All Guests for the wedding')
    bride_list = self.guest_lists.create!(:name => 'Bride', :description => "The Bride's guests to the wedding")
    groom_list = self.guest_lists.create!(:name => 'Groom', :description => "The Groom's guests to the wedding")

    create_guest(all_guests, bride, bride_email, bride_list)
    create_guest(all_guests, groom, groom_email, groom_list)
  end

  def details(current_user=nil)
    {
      :wedding => name,
      :date => on,
      :image_path => image.thumb.url,
      :editable => [bride_email, groom_email].include?(current_user.try(:email))
    }
  end

  def guest_names
    guests.map(&:users).flatten.compact.map(&:nickname)
  end

private

  def create_guest(list, name, email, guest_list)
    created_guest = list.guests.create!(
      :name => name,
      :email => email,
      :seats => 1,
      :wedding => self
    )

    if user = User.find_by_email(email)
      created_guest.permissions.create(:user => user, :list => guest_list)
    end

    created_guest.confirm!
  end

  class List < SimpleDelegator
    def for(email)
      if groom_email == email
        groom_list
      elsif bride_email == email
        bride_list
      end
    end

    def groom_list
      guest_lists.where(:name => 'Groom').first
    end

    def bride_list
      guest_lists.where(:name => 'Bride').first
    end
  end

end
