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
      @wedding.guests
    else
      @wedding.guests.for(owner)
    end
  end

  def owner
    @params[:owner] || 'All'
  end

  def can_add_guest?
    owner != 'All'
  end

  def display_owner?
    !can_add_guest?
  end
end
