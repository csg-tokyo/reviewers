class ReviewersController < ApplicationController
  include Common

  before_action :set_reviewer_for_admin, only: [:show, :destroy, :edit, :update]
  before_action :is_admin?, only: [:index, :create, :new]

  # GET /reviewers
  # GET /reviewers.json
  def index
    @reviewers = Reviewer.all
  end

  # GET /reviewers/1
  # GET /reviewers/1.json
  def show
  end

  # GET /reviewers/new
  def new
    @reviewer = Reviewer.new
  end

  # GET /reviewers/1/edit
  def edit
  end

  # POST /reviewers
  # POST /reviewers.json
  def create
    @reviewer = Reviewer.new(reviewer_params)

    respond_to do |format|
      if @reviewer.save
        format.html { redirect_to @reviewer, notice: 'Reviewer was successfully created.' }
        format.json { render :show, status: :created, location: @reviewer }
      else
        format.html { render :new }
        format.json { render json: @reviewer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviewers/1
  # PATCH/PUT /reviewers/1.json
  def update
    respond_to do |format|
      if @reviewer.update(reviewer_params)
        format.html { redirect_to @reviewer, notice: 'Reviewer was successfully updated.' }
        format.json { render :show, status: :ok, location: @reviewer }
      else
        format.html { render :edit }
        format.json { render json: @reviewer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviewers/1
  # DELETE /reviewers/1.json
  def destroy
    @reviewer.destroy
    respond_to do |format|
      format.html { redirect_to reviewers_url, notice: 'Reviewer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reviewer_for_admin
      if logged_in_as_admin?
        @reviewer = Reviewer.find(params[:id])
      else
        @reviewer = nil
        force_admin_login
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reviewer_params
      params.require(:reviewer).permit(:article_id, :name, :affiliation, :email)
    end
end
