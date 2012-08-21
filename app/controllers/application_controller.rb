class ApplicationController < ActionController::Base
  layout 'sidebar'
  protect_from_forgery

  before_filter :authenticate_user!, :my_wedding

  def my_wedding
    if current_user && wedding
      unless current_user.guest_of?(wedding)
        render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => nil
      end
    end
  end

  def wedding
    Wedding.find_by_id(params[:wedding_id])
  end
end
