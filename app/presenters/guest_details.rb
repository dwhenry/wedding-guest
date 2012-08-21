class GuestDetails
  def initialize(wedding, params)
    @wedding = wedding
    @params = params
  end

  def guest_owners
    @wedding.guest_owners.order(:id).map do |guest_owner|
      classname = guest_owner.name == owner ? 'selected' : ''
      [guest_owner, classname]
    end
  end

  def guests
    case owner
    when 'All'
      wrap @wedding.guests.order('guests.name')
    else
      wrap @wedding.guests.for(owner).order('guests.name')
    end
  end

  def wrap(guests)
    guests.map do |guest|
      GuestWrapper.new guest
    end
  end

  def owner
    @params[:owner] || 'All'
  end

  def guest_owner_id
    @wedding.guest_owners.where(:name => owner).first.id
  end

  def can_add_guest?(user)
    owner != 'All' &&
    owner == user.permissions.for_wedding(@wedding).first.list.try(:name)
  end

  def can_edit_guest?(user)
    for_wedding = user.permissions.for_wedding(@wedding).first

    (owner == 'All' && for_wedding) ||
    owner == for_wedding.list.try(:name)
  end

  class GuestWrapper < SimpleDelegator
    def prefix(tab)
      (display_owner?(tab) ? "(#{owner.name})" : '')
    end

    def full_name(tab)
      if display_owner?(tab)
        "#{name} #{prefix(tab)}"
      else
        name
      end
    end

    def display_owner?(tab)
      (tab.blank? || tab == 'All') && owner.name != 'All'
    end
  end
end
