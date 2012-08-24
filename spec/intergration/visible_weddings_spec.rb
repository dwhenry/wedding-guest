require 'spec_helper'

feature 'visible weddings' do
  let (:wedding) { create(:wedding) }
  let (:guest) { create(:guest, :wedding => wedding) }

  scenario 'includes weddings where user is bride' do
    login_as wedding.bride_email

    visit weddings_path

    page.should have_css('tr', :text => wedding.name)
  end

  scenario 'includes weddings where user is groom' do
    login_as wedding.groom_email

    visit weddings_path

    page.should have_css('tr', :text => wedding.name)
  end

  scenario 'includes weddings where user is guest' do
    login_as guest.email

    visit weddings_path

    page.should have_css('tr', :text => wedding.name)
  end

  scenario 'does not include weddings where user is not one of bride/guest/guest' do
    login_as create(:user).email

    visit weddings_path

    page.should_not have_css('tr', :text => wedding.name)
  end

end