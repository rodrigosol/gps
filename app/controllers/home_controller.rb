
class HomeController < ApplicationController
  @@requests = []
  def index
    logger.info(request.env.inspect)
    render :text => request.env.inspect
  end
  
end
