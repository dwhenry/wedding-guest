class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]
  has_many :permissions, :class_name => 'GuestPermission'
  has_many :guests, :through => :permissions
  has_many :weddings, :through => :guests

  validates_presence_of :nickname
  validates_uniqueness_of :nickname

  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :nickname, :email, :password, :password_confirmation, :remember_me

  after_save :attach_user

  def attach_user
    Guest.find_all_by_email(email).each do |guest|
      Guest::Permissions.new(guest).ensure_permissions_for(self)
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(nickname) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def guest_of?(wedding)
    weddings.include?(wedding) && guest_for(wedding).confirmed?
  end

  def guest_for(wedding)
    (wedding.guests & guests).tap do |array|
      raise 'Guest Invited to wedding twice.  Please investigate' if array.size > 1
    end.first
  end
end
