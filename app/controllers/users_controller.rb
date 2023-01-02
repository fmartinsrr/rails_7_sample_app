class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
  		@users = User.all
	end

	def show
	end

	def edit
	end

  def new
		@user = User.new
		@user.status = :enable
  end

  def create
		@user = User.new(user_params)
		if @user.save
			redirect_to users_url
		else
			render 'new'
		end
	end

	def update
		if @user.update(user_params)
			redirect_to users_url
		else
			render 'edit'
		end
	end

	def destroy
		if @user.destroy
			redirect_to users_url
		end
	end

	private

	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:username, :status)
	end

end