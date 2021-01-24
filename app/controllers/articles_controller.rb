class ArticlesController < ApplicationController
  include Common

  before_action :set_article, only: [:show]
  before_action :set_article_for_owner, only: [:edit, :update, :destroy,
    :reviewing_begins, :review_request, :report, :accept_letter,
    :reject_letter, :final_accept_letter]
  before_action :is_user?, only: [:index, :all_index, :my_index,
                                  :approval_index, :search,
                                  :issue, :new, :create]
  before_action :is_admin?, only: [:approval_index_for_admin, :issue_done]

  # GET /articles
  # GET /articles.json
  def index
    if logged_in_as_guest?
      my_index
    else
      @articles = Article.fetch_index
                         .where(done: false).order(name: :asc)
    end
  end

  def all_index
    if logged_in_as_admin?
      @articles = Article.fetch_index
                         .all.order(name: :desc)
    else
      index
    end
  end

  def my_index
    @articles = Article.includes(:conflicts, :actionlogs, :reviews,
                                 :submissions_info)
                       .joins(:editors)
                       .where(done: false, editors: { user: current_user })
                       .order(created_at: :desc)
  end

  # GET /approvals
  def approval_index
#    The following query didn't work.  The full Submission object was loaded.
#    @articles = Article.includes(:editors, :conflicts, :actionlogs,
#                                 :submissions_info)
#                       .joins(:reviews)
#                       .where(done: false, approved: false,
#                              reviews: { kind: Review::FINAL_REPORT })
#                       .order(name: :asc)
    if logged_in_as_guest?
      @articles = []
    else
      results = Article.fetch_index
                       .where(done: false, approved: false)
                       .order(name: :asc)
      @articles = results.reject {|a| a.final_decision.nil? }
    end
  end

  # GET /approvals_info
  # GET /approvals_info.json
  def approval_index_for_admin
    results = Article.includes(:editors, :authors, :reviewers, :reviews)
                     .where(done: false, approved: false)
                     .order(name: :asc)
    @articles = results.reject {|a| a.final_decision.nil? }
    respond_to do |format|
      format.html
      format.json { render :json => @articles.map {|a| a.to_json } }
    end
  end

  # GET /issue/30/1
  # GET /articles#issue/30/1
  def issue
    @volume = params[:volume].to_i
    @number = params[:number].to_i
    @articles = Article.includes(:conflicts, :submissions_info, :reviews)
                       .where(volume: @volume, number: @number)
                       .order(:position)
  end

  # PUT /issue/30/1
  def issue_done
    volume = params[:volume].to_i
    number = params[:number].to_i
    respond_to do |format|
      if Article.where(volume: volume, number: number)
                .update_all(done: true)
        format.html { redirect_to articles_url, notice: 'Articles were successfully marked as DONE.' }
        format.json { head :no_content }
      end
    end
  end

  # GET /search/17-R-
  def search
    pat = params[:pattern]
    if pat.nil? || pat !~ /^[A-z0-9_-]*$/ || logged_in_as_guest?
      @articles = []
      @pattern = 'error'
    else
      pattern = '%' + pat + '%'
      @pattern = pat
      @articles = Article.fetch_index
                         .where('name like ?', pattern).order(name: :asc)
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/1/reviewing_begins/1
  def reviewing_begins
    @number = params[:number]
  end

  # GET /articles/1/editor_request
  def editor_request
    @article = Article.find(params[:id])
  end

  # GET /articles/1/review_request/1
  def review_request
    @number = params[:number]
  end

  # GET /articles/1/report/1
  def report
    @article = Article.find(params[:id])
    @number = params[:number]
    if @number == "1"
      abc = Review::first_reviews(@article.reviews)
    elsif @number == "2"
      abc = Review::second_reviews(@article.reviews)
    else
      abc = [nil, nil, nil]
    end

    @review_a = abc[0]
    @review_b = abc[1]
    @review_c = abc[2]
  end

  # GET /articles/1/accept_letter
  def accept_letter
    collect_final_reviews
  end

  # GET /articles/1/reject_letter
  def reject_letter
    collect_final_reviews
  end

  # GET /articles/1/final_accept_letter
  def final_accept_letter
  end

  # GET /articles/new
  def new
    @article = Article.new
    @article.authors.build
    3.times { @article.reviewers.build }
  end

  # GET /articles/1/edit
  def edit
    # for some reason, an empty list is set to @article.reviewers
    if @article.reviewers.nil? or @article.reviewers.length == 0
      3.times { @article.reviewers.build }
    end
  end

  # POST /articles
  # POST /articles.json
  def create
    ap = article_params.to_h
    aut = ap.delete :authors_attributes
    rev = ap.delete :reviewers_attributes

    @article = Article.new(ap)
    success = @article.save
    if success
      aut.each do |k,a|
        destroy_flag = a.delete :_destroy
        if destroy_flag || !@article.invalid_author(a)
          success = @article.authors.build(a).save
        end
      end
      if not rev.nil?
        rev.each do |k,a|
          success = @article.reviewers.build(a).save && success
        end
      end
    end

    respond_to do |format|
      if success
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      if logged_in?
        @article = Article.find(params[:id])
        if !logged_in_as_oneof?(@article.conflicts)
          return
        else
          @article = nil
        end
      end

      force_login
    end

    def set_article_for_owner
      @article = Article.find(params[:id])
      unless logged_in_as_oneof?(@article.editors) ||
             logged_in_as_admin?
        @article = nil
        flash[:danger] = "Please log in as an administrator."
        redirect_to login_url
        end
    end

    def is_user?
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def is_admin?
      unless logged_in_as_admin?
        flash[:danger] = "Please log in as an administrator."
        redirect_to login_url
      end
    end

    def collect_final_reviews
      @article = Article.find(params[:id])
      rev = Review::third_reviews(@article.reviews)
      @number = "3"
      if [nil, nil, nil].eql? rev
        rev = Review::second_reviews(@article.reviews)
        @number = "2"
        if [nil, nil, nil].eql? rev
          rev = Review::first_reviews(@article.reviews)
          @number = "1"
        end
      end

      @review_a = rev[0]
      @review_b = rev[1]
      @review_c = rev[2]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(
                    :name, :title, :etitle, :created_at, :memo, :done,
                    :article_type, :category, :is_letter, :pages, :decision,
                    :article_type_name, :member,
                    :volume, :number, :position, :approved, :abstract,
                    :contact, :ethics,
                    authors_attributes: [:id, :_destroy,
                                         :name, :affiliation, :email],
                    reviewers_attributes: [:id, :name, :affiliation, :email],
                    conflict_user_ids: [],
                    user_ids: [])
    end
end
