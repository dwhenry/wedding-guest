class GuestDetails
  def initialize(wedding, params)
    @wedding = wedding
    @params = params
  end

  def guest_lists(user=nil)
    lists = @wedding.guest_lists.for(user).order('guest_lists.id')
    lists.map do |guest_list|
      classname = guest_list.name == list_name ? 'selected' : ''
      [guest_list, classname]
    end
  end

  def guests(user)
    if list_owner?(user)
      case list_name
      when 'All'
        wrap @wedding.guests.order('guests.name')
      else
        wrap @wedding.guests.for(list_name).order('guests.name')
      end
    else
      wrap @wedding.guests.where(:status => 'Confirmed').order('guests.name')
    end
  end

  def list_owner?(user)
    !user.permissions.for_wedding(@wedding).with_list.empty?
  end

  def owner?(user)
    @wedding.owner?(user)
  end

  def wrap(guests)
    guests.map do |guest|
      GuestWrapper.new guest
    end
  end

  def list_name
    @params[:list] || 'All'
  end

  def guest_list_id
    @wedding.guest_lists.where(:name => list_name).first.id
  end

  def can_add_guest?(user)
    list_name != 'All' &&
    list_name == user.permissions.for_wedding(@wedding).first.list.try(:name)
  end

  def can_edit_guest?(user)
    for_wedding = user.permissions.for_wedding(@wedding).first

    (list_name == 'All' && for_wedding) ||
    list_name == for_wedding.list.try(:name)
  end

  class GuestWrapper < SimpleDelegator
    def prefix(tab)
      (display_owner?(tab) ? "(#{list.name})" : '')
    end

    def full_name(tab)
      if display_owner?(tab)
        "#{name} #{prefix(tab)}"
      else
        name
      end
    end

    def display_owner?(tab)
      (tab.blank? || tab == 'All') && list.name != 'All'
    end
  end
end
