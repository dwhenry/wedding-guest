module Users
  class SessionsController < Devise::SessionsController
    def create
      resource = warden.authenticate!(:scope => resource_name, :recall => :failure)
      return sign_in_and_redirect(resource_name, resource)
    end

    def sign_in_and_redirect(resource_or_scope, resource=nil)
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      resource ||= resource_or_scope
      sign_in(scope, resource) unless warden.user(scope) == resource

      respond_to do |format|
        format.html { respond_with resource, :location => after_sign_in_path_for(resource) }
        format.json  {
          resource.reset_authentication_token
          resource.save!
          # render :json => {:success => true, :auth_token => resource.authentication_token}
          render :text => resource.authentication_token
        }
      end
    end

    def failure
      debugger
      respond_to do |format|
        format.html {  }
        format.json  { render :json => {:success => false, :errors => ["Login failed."]} }
      end
    end
  end
end