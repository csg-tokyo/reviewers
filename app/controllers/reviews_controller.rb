class ReviewsController < ApplicationController
  include Common

  before_action :set_review_for_owner, only: [:edit, :update, :destroy]
  before_action :set_review, only: [:show]
  before_action :is_admin?, only: [:index]
  before_action :is_user?, only: [:create, :new]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
    if params[:article_id] == nil
      @review.article_id = review_params[:article_id]
    else
      @review.article_id = params[:article_id]
    end
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    send_notification # unless Rails.env.development?
    respond_to do |format|
      if is_owner?(@review.article) && @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    send_notification
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def send_notification
      if @review.is_final_report
        NotifyMailer.send_to_notify(@review.article,
                                    @review.kind_name).deliver_now
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_review_for_owner
      @review = Review.find(params[:id])
      unless is_owner?(@review.article)
        @review = nil
        force_admin_login
      end
    end

    def set_review
      if logged_in?
        @review = Review.find(params[:id])
        if !logged_in_as_oneof?(@review.article.conflicts)
          return
        else
          @review = nil
        end
      end

      force_login
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:article_id, :created_at, :kind, :decision, :award, :to_editor, :to_author, :memo)
    end
end
