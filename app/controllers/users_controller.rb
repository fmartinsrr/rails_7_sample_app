class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
		session[:user_page] = :user_index
  	@users = User.all
	end

	def show
		session[:user_page] = :user_details
	end

	def edit
		session[:user_page] = :edit_user
	end

  def new
		session[:user_page] = :new_user
		@user = User.new
		@user.status = :enable
  end

  def create
		@user = User.new(user_params)
		if @user.save
			WelcomeUserJob.perform_async(@user.id)
			redirect_to users_url
		else
			render 'new'
		end
	end

	def update
		if !session[:user_page].nil? && session[:user_page] == :user_details.to_s
			user_param = params[:user]
			if !user_param.nil? && !user_param[:picture].nil?
				result = Cloudinary::Uploader.upload(params[:user][:picture], options = {})
				@user.update(image_public_id: result["public_id"], image_public_url: result["url"])
				redirect_to user_path(@user)
			end
		else
			if @user.update(user_params.except(:picture))
				redirect_to users_url
			else
				render 'edit'
			end
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
		params.require(:user).permit(:username, :email, :password, :status, :picture)
	end

end