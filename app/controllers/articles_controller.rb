class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
  
  def index 
    respond_to do |format|
      @articles = Article.all
      format.json { render json: {articles: @articles}, status: :ok }
      format.html 
    end
  end
  
  def show
    respond_to do |format|
      begin
      	@article = Article.find(params[:id])
        format.html 
        format.json { render json: {article: @article}, status: :ok }
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
        format.html { render html: {error: e.message} }
      end
    end
  end
  
  def new
    @article = Article.new
  end
  
  def edit
  	respond_to do |format|
      begin
        @article = Article.find(params[:id])
       	format.html 
       	format.json { render json: {article: @article}, status: :ok }
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
        format.html { render html: {error: e.message} }
      end
    end	
  end
  
  def create
    respond_to do |format|
      begin 
        @article = Article.new(article_params)
   	    if @article.save 
          format.json { render json: {article: @article}, status: :ok }
       	  format.html { redirect_to @article }
        else
          format.json { render json: {article: @article.errors}, status: :unprocessable_entity }
          format.html { render html: {article: @article.errors} }
        end
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
       	format.html { render 'new' }
      end
   	end
  end
  
  def update
    respond_to do |format|
      begin 
        @article = Article.find(params[:id])
        if @article.update(article_params)
          format.json { render json: {article: @article}, status: :ok }
          format.html { redirect_to @article }
	      else
          format.json { render json: {article: @article.errors}, status: :unprocessable_entity }
          format.html { render html: {article: @article.errors} }
        end
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
        format.html { render 'edit' }
  	  end
  	end
  end
  
  def destroy
   	respond_to do |format|
	    begin 
	  	  @article = Article.find(params[:id])
	  	  if @article.destroy
       	  format.json { render json: {mesage: "Deleted!"}, status: :ok }
       	  format.html { redirect_to articles_path }
        else
          format.json { render json: {article: @article.errors}, status: :unprocessable_entity }
          format.html { render html: {article: @article.errors} }
        end
      rescue => e
        format.json { render json: {message: e.message}, status: :unprocessable_entity }
        format.html { render html: {message: e.message} }
      end
    end
  end
  
  private
  
  def article_params
 	  params.require(:article).permit(:title, :text)
	end
end