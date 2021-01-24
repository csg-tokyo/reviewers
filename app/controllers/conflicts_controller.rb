class ConflictsController < ApplicationController
  include Common

  before_action :set_conflict, only: [:show, :edit, :update, :destroy]
  before_action :is_admin?, only: [:index, :create, :new]

  # GET /conflicts
  # GET /conflicts.json
  def index
    @conflicts = Conflict.all
  end

  # GET /conflicts/1
  # GET /conflicts/1.json
  def show
  end

  # GET /conflicts/new
  def new
    @conflict = Conflict.new
  end

  # GET /conflicts/1/edit
  def edit
  end

  # POST /conflicts
  # POST /conflicts.json
  def create
    @conflict = Conflict.new(conflict_params)

    respond_to do |format|
      if @conflict.save
        format.html { redirect_to @conflict, notice: 'Conflict was successfully created.' }
        format.json { render :show, status: :created, location: @conflict }
      else
        format.html { render :new }
        format.json { render json: @conflict.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conflicts/1
  # PATCH/PUT /conflicts/1.json
  def update
    respond_to do |format|
      if @conflict.update(conflict_params)
        format.html { redirect_to @conflict, notice: 'Conflict was successfully updated.' }
        format.json { render :show, status: :ok, location: @conflict }
      else
        format.html { render :edit }
        format.json { render json: @conflict.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conflicts/1
  # DELETE /conflicts/1.json
  def destroy
    @conflict.destroy
    respond_to do |format|
      format.html { redirect_to conflicts_url, notice: 'Conflict was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conflict
      @conflict = Conflict.find(params[:id])
      if !logged_in_as_admin?
        @conflict = nil
        force_admin_login
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conflict_params
      params.require(:conflict).permit(:article_id, :user_id)
    end
end
