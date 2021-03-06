module LoginHelper
  def login_as(user_email)
    user =  User.find_by_email(user_email) || create(:user, :email => user_email)

    visit new_user_session_path
    page.fill_in 'Login', :with => user.email
    page.fill_in 'Password', :with => 'password'
    page.click_on 'Sign in'
  end
end

include LoginHelper