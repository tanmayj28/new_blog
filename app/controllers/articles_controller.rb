class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
#Controller is simply a class that inherits from ApplicationController.
#Methods defined here will become actions for this controller.
  def index
    @articles = Article.all
  end

  def show
    if Article.find(params[:id])
      respond_to do |format|
       	format.json { render json: {article: @article}, status: :ok }
       	format.html { @article= Article.find(params[:id]) }
      end
    else
      respond_to do |format|
        format.json { render json: {article: @article}, status: :unprocessable_entity }
      end	
    end
  end

  def new
    @article = Article.new
  end

  def edit
    if Article.find(params[:id])
      respond_to do |format|
       	format.json { render json: {article: @article}, status: :ok }
       	format.html { @article = Article.find(params[:id]) }
      end
    else
      respond_to do |format|
        format.json { render json: {article: @article}, status: :unprocessable_entity }
      end	
    end
  end

  def create
    @article = Article.new(article_params)
   	if @article.save
      respond_to do |format|
       	format.json { render json: {article: @article}, status: :ok }
       	format.html { redirect_to @article }
      end
   	else
      respond_to do |format|
        format.json { render json: {article: @article}, status: :unprocessable_entity }
       	format.html { render 'new' }
      end
   	end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
	  redirect_to @article
	else
      render 'edit'
	end
  end

  def destroy
    @article = Article.find(params[:id])
	if @article.destroy
	  respond_to do |format|
       	format.json { render json: {article: @article}, status: :ok }
       	format.html { redirect_to articles_path }
      end
    else
      respond_to do |format|
        format.json { render json: {article: @article}, status: :unprocessable_entity }
      end
   	end
  end

  private
    def article_params
   	  params.require(:article).permit(:title, :text)
  	end
end