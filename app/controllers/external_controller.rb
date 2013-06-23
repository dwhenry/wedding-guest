class ExternalController < ApplicationController
  def authenticate_user!
    true
  end

  def show
    @wedding = Wedding.find_by_param_name(params[:wedding_name])
    if @wedding.nil?
      redirect_to new_user_session_path
    else
      @name = params[:name] || :home
    end
  end
end