class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @user_id = params[:user_id] unless params.nil?
    @article_id = params[:article_id] unless params.nil?
    session[:return_to] ||= request.referer
  end

  def create
    @comment = Comment.new(comment_params.except(:user_id).except(:article_id))
		assign_to_user_if_needed(@comment, params[:comment][:user_id])
    assign_to_article_if_needed(@comment, params[:comment][:article_id])
		if @comment.save
			redirect_to session.delete(:return_to)
		else
			render 'new'
		end
  end

  def assign_to_user_if_needed(comment, user_id)
    if user_id
      user = User.find(user_id)
      comment.commentable = user
    end
  end

  def assign_to_article_if_needed(comment, article_id)
    if article_id
      article = User.find(article_id)
      comment.commentable = article
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
			redirect_to request.referer
		end
  end

  private

  def comment_params
		params.require(:comment).permit(:comment, :user_id, :article_id)
	end

end