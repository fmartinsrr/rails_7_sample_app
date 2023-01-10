class ArticlesController < ApplicationController
	before_action :set_article, only: [:show, :edit, :update, :destroy]
	before_action :require_login, only: [:new, :edit, :destroy]

	def index
    status_symbol = params[:status].to_sym if params[:status] != nil
    status_symbol ||= params[:article_status][:status].to_sym if params[:article_status].present? && params[:article_status][:status].present?
    @status = status_symbol if Article.statuses.include?(status_symbol)
    @filter_user = params[:article_status][:user_id] if params[:article_status].present? && params[:article_status][:user_id].present?
    @article_users = User.joins(:articles).distinct

    # params[:article_status][:tags_id].compact_blank == params[:article_status][:tags_id].reject(&:empty?)

    @filter_tags = params[:article_status][:tags_id].compact_blank if params[:article_status].present? && params[:article_status][:tags_id].present?
    @article_tags = Tag.joins(:articles).distinct

    @articles = Article.all
    @articles = @articles.filter_by_status(@status) unless @status.nil?
    @articles = @articles.filter_by_tag(@filter_tags) unless @filter_tags.nil? || @filter_tags.empty?
    @articles = @articles.filter_by_user(@filter_user) unless @filter_user.blank?
    @articles = @articles.includes(:user).includes(:article_tags).includes(:tags)

    # NON OPTIMIZED:
    #@articles = if @status != nil
    #  if @filter_user != nil && @filter_user != ""
    #    #Article.filter_by_status_and_user(@status, @filter_user)
    #    Article.filter_by_status(@status).filter_by_user(@filter_user)
    #  else
    #    Article.filter_by_status(@status)
    #  end
    #elsif @filter_user != nil && @filter_user != ""
    #  Article.filter_by_user(@filter_user)
    #else
    #  Article.all
    #end
	end

	def live
    @articles = Article.filter_by_status(:live)
	end

	def show
	end

	def edit
    @need_reload = false
	end

  def new
		@article = Article.new
    @article.status = :draft
    @need_reload = false
  end

  def create
		@article = Article.new(article_params.except(:tags))
		update_article_tags(@article, params[:article][:tags])
		if @article.save
			redirect_to articles_url
		else
			render 'new'
		end
	end

	def update
    @need_reload = false
    did_succeed = false
    
    Article.transaction do 
      update_article_tags(@article, params[:article][:tags])
      did_succeed = @article.update(article_params.except(:tags))
    end

    if did_succeed
      redirect_to articles_url
    else
      render 'edit'
    end

  rescue ActiveRecord::StaleObjectError => e
    flash[:notice] = "The article was modified while you were editing it. Please retry..."
    @need_reload = true
    render 'edit'
	end

  def update_article_tags(article, tags_names)
    article.article_tags.destroy_all
    tags_names = tags_names.strip.split(',')
    article.tags = tags_names.map { |name|
        Tag.find_or_create_by(name: name)
    }
  end

	def destroy
		if @article.destroy
			redirect_to articles_url
		end
	end

	private

	def set_article
		@article = Article.find(params[:id])
	end

	def article_params
		params.require(:article).permit(:title, :description, :status, :user_id, :tags, :update_count)
	end

  def require_login
    if !logged_in?
      flash[:warning] = "To create a new article you need to log in"
      redirect_to login_path
    end
  end

end