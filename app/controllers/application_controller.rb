class ApplicationController < ActionController::Base
  layout 'sidebar'
  protect_from_forgery

  before_filter :authenticate_user!
end
