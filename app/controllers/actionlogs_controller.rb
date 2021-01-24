class ActionlogsController < ApplicationController
  include Common

  before_action :set_actionlog_for_owner, only: [:show, :edit, :update, :destroy]
  before_action :is_admin?, only: [:index]
  before_action :is_user?, only: [:create, :new]

  # GET /actionlogs
  # GET /actionlogs.json
  def index
    @actionlogs = Actionlog.all
  end

  # GET /actionlogs/1
  # GET /actionlogs/1.json
  def show
  end

  # GET /actionlogs/new
  def new
    @actionlog = Actionlog.new
    if params[:article_id] == nil
      @actionlog.article_id = actionlog_params[:article_id]
    else
      @actionlog.article_id = params[:article_id]
    end
  end

  # GET /actionlogs/1/edit
  def edit
  end

  # POST /actionlogs
  # POST /actionlogs.json
  def create
    @actionlog = Actionlog.new(actionlog_params)
    send_notification
    respond_to do |format|
      if is_owner?(@actionlog.article) && @actionlog.save
        format.html { redirect_to @actionlog, notice: 'Actionlog was successfully created.' }
        format.json { render :show, status: :created, location: @actionlog }
      else
        format.html { render :new }
        format.json { render json: @actionlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /actionlogs/1
  # PATCH/PUT /actionlogs/1.json
  def update
    send_notification
    respond_to do |format|
      if @actionlog.update(actionlog_params)
        format.html { redirect_to @actionlog, notice: 'Actionlog was successfully updated.' }
        format.json { render :show, status: :ok, location: @actionlog }
      else
        format.html { render :edit }
        format.json { render json: @actionlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /actionlogs/1
  # DELETE /actionlogs/1.json
  def destroy
    @actionlog.destroy
    respond_to do |format|
      format.html { redirect_to actionlogs_url, notice: 'Actionlog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def send_notification
      if @actionlog.is_camera_ready?
        NotifyMailer.send_to_notify(@actionlog.article,
                                    @actionlog.kind_name).deliver_now
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_actionlog_for_owner
      @actionlog = Actionlog.find(params[:id])
      unless is_owner?(@actionlog.article)
        @actionlog = nil
        force_admin_login
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def actionlog_params
      params.require(:actionlog).permit(:article_id, :created_at, :kind)
    end
end
