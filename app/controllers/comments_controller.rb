class CommentsController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy
  def index
    @comments = Comment.all
    respond_to do |format|
      format.html { render html: {comments: @comments}, status: :ok }
      format.json { render json: {comments: @comments}, status: :ok }
    end
  end
  def create
    begin 
      if @article = Article.find(params[:article_id])
        @comment = @article.comments.create(comment_params)
        redirect_to article_path(@article)
      end
    rescue => e
      format.html { render html: {error: e.message } }
      format.json { render json: {error: e.message }, status: RecordNotFound }
    end
  end
  def show
  end
  def destroy
 	  @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
      respond_to do |format|
        format.json { render json: {article: @article}, status: :ok }
        format.html { redirect_to article_path(@article) }
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.json { render json: {error: RecordNotFound} }
        format.html { render html: {error: RecordNotFound} }
      end
  end
  private
    def comment_params
      params.require(:comment).permit(:commneter, :body, :article_id)
    end
end