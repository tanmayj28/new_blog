class CommentsController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy

  def index
    @comments = Comment.all 
    respond_to do |format|
      format.html 
      format.json { render json: {comments: @comments}, status: :ok }
    end
  end
  
  def new
    @comment= Comment.new
  end
  
  def create
    begin
      @comment = Comment.new(comment_params)
      @article = Article.find(@comment.article_id)
      respond_to do |format|
        if @comment.save
          format.html { redirect_to article_path(@article) }
          format.json { render json: {comment: @comment}, status: :ok }
        else
          format.json { render json: {comment: @comment.errors}, status: :unprocessable_entity }
          format.html { render html: {comment: @comment.errors} }
        end
      end
    rescue => e
      respond_to do |format|
        format.html { render 'new' }
        format.json { render json: {error: e.message }, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    begin
      @comment = Comment.find(params[:id])
      respond_to do |format|
        format.json { render json: {comment: @comment}, status: :ok }
        format.html 
      end
    rescue => e
      respond_to do |format|
        format.json { render json: {comment: e.message}, status: :RecordNotFound }
        format.html { render html: {comment: e.message} }
      end
    end 
  end
  
  def destroy
    begin 
      @comment = Comment.find(params[:id])
      if @comment.destroy
        respond_to do |format|
          format.json { render json: {message: "deleted!"}, status: :ok }
          format.html { redirect_to request.referrer }
        end
      else
        respond_to do |format|
          format.json { render json: {comment: @comment.errors}, status: :unprocessable_entity }
          format.html { render html: {comment: @comment.errors} }
        end
      end
    rescue => e
      respond_to do |format|
        format.json { render json: {comment: e.message}, status: :RecordNotFound }
        format.html { render html: {comment: e.message} }
      end
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:commneter, :body, :article_id)
  end
end