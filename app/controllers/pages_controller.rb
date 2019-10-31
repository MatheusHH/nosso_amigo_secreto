class PagesController < ApplicationController
  def home
  	if current_user
  	  @campaigns = Campaign.where(user_id: current_user.id)
  	end
  end
end
