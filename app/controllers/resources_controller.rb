class ResourcesController < ApplicationController

  def image_cache
    headers['Cache-Control'] = 'public; max-age=600' # cache image for 10 minutes
    send_file "#{RAILS_ROOT}/tmp/uploads/#{params['cache_id']}/#{params['filename']}", :disposition => 'inline', :type => "image/png"
  end
  # Usage
  # = image_tag(resource_image_cache_path(:cache_id => resource.avatar_cache[/^[\d-]+/], :filename => resource.avatar_cache[/[a-zA-Z0-9 _\.]+$/])) if resource.avatar_cache
end