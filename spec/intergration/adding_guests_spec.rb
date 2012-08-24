require 'spec_helper'

feature 'adding guests', :js => true do
  let (:wedding) { build(:wedding).tap{|w| w.save!} }
  let (:guest) { create(:guest, :wedding => wedding, :owner => wedding.guest_owners.last) }
  let (:user) { create(:user, :email => user_email) }

  scenario 'bride can only add bride guests' do
    login_as wedding.bride_email

    visit wedding_guests_path(wedding)

    can_not_create_guest_for('All')
    can_create_guest_with_keyboard_for('Bride')
    can_not_create_guest_for('Groom')
  end

  scenario 'groom can only add groom guests' do
    login_as wedding.groom_email

    visit wedding_guests_path(wedding)

    can_not_create_guest_for('All')
    can_not_create_guest_for('Bride')
    can_create_guest_with_keyboard_for('Groom')
  end

  scenario 'additional guest owner can add guests to personal list' do
    guest && user
    list = create(:guest_owner, :wedding => wedding, :name => 'MOB')
    guest.permissions.last.update_attributes(:list => list)

    login_as guest.email

    visit wedding_guests_path(wedding)

    can_not_create_guest_for('All')
    can_not_create_guest_for('Bride')
    can_not_create_guest_for('Groom')
    can_create_guest_with_keyboard_for('MOB')
  end

  def can_not_create_guest_for(tab_name)
    click_on tab_name
    page.should have_no_content '+ Add Guest'
  end

  def can_create_guest_with_keyboard_for(tab_name)
    click_on tab_name
    page.find('table.editable tfoot tr', :text => '+ Add Guest').click
    key_down_for "#input",           # field identifier
                 "keyboard guest\t", # guest name
                 "3\t",              # guest seats
                 "guest@test.com\t"  # guest contact
    wait_until { page.has_no_content?('Saving') }
    wedding.guests.where(:name => 'keyboard guest').should_not be_empty
  end

  def can_create_guest_with_keyboard_and_mouse_for(tab_name)
    click_on tab_name
    page.should have_content '+ Add Guest'
    element = page.find('td', :text => '+ Add Guest')
    fill_in '#input', :with => 'keybord and mouse guest'

    wedding.guests.where(:name => 'keybord and mouse guest').should_not be_nil
  end
end