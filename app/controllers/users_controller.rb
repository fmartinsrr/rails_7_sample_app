class UsersController < ApplicationController
	
	def index
  		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

  def new
		@user = User.new
  end

  def create
		@user = User.new(params.require(:user).permit(:username))
		if @user.save
			redirect_to users_url
		else
			render 'new'
		end
	end

	def update
		@user = User.find(params[:id])
		if @user.update(params.require(:user).permit(:username))
			redirect_to users_url
		else
			render 'edit'
		end
	end

end