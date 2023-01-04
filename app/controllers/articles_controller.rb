class ArticlesController < ApplicationController
	before_action :set_article, only: [:show, :edit, :update, :destroy]
	before_action :require_login, only: [:new, :edit, :destroy]

	def index
  		@articles = Article.all
	end

	def live
    @articles = Article.where(status: :live)
	end

	def show
	end

	def edit
	end

  def new
		@article = Article.new
    @article.status = :draft
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
		@article.update_count += 1
		update_article_tags(@article, params[:article][:tags])
		if @article.update(article_params.except(:tags))
			redirect_to articles_url
		else
			render 'edit'
		end
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
		params.require(:article).permit(:title, :description, :status, :user_id, :tags)
	end

  def require_login
    if !logged_in?
      flash[:warning] = "To create a new article you need to log in"
      redirect_to login_path
    end
  end

end