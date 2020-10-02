class FeedsController < ApplicationController

  before_action :set_feed, only: [:show, :edit, :update, :destroy]
  before_action :need_login, only: [:index, :new, :edit, :show, :destroy]

  def index
    @feeds = Feed.all.order(created_at: :desc)
    if params[:back]
      @feed = Feed.new(feed_params)
    else
      @feed = Feed.new
    end
  end

  def show
  end

  def new
      if params[:back]
        @feed = Feed.new(feed_params)
      else
        @feed = Feed.new
      end
  end

  def confirm
    @feed = current_user.feeds.build(feed_params)
    render :new if @feed.invalid?
  end

  def edit
  end

  def create
    @feed = current_user.feeds.build(feed_params)
    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: '投稿しました' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user == @feed.user
      respond_to do |format|
        if @feed.update(feed_params)
          format.html { redirect_to @feed, notice: '更新しました' }
          format.json { render :show, status: :ok, location: @feed }
        else
          format.html { render :edit }
          format.json { render json: @feed.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    if current_user == @feed.user
      @feed.destroy
      respond_to do |format|
        format.html { redirect_to feeds_url, notice: '投稿を削除しました' }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:image, :content, :image_cache)
    end

    def need_login
      unless logged_in?
        authenticate_user
      end
    end

end
