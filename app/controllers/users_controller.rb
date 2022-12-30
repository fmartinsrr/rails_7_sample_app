class UsersController < ApplicationController

	def index
  		@users = User.all
	end

  def new
  end

  def create
		user = User.new(params.require(:user).permit(:username))
		if user.save
			redirect_to users_url
		end
	end
	
end