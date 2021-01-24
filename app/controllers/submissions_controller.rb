class SubmissionsController < ApplicationController
  include Common

  before_action :set_submission, only: [:show]
  before_action :set_submission_for_download, only: [:download]
  before_action :set_submission_for_owner, only: [:edit, :update, :destroy]
  before_action :is_admin?, only: [:index]
  before_action :is_user?, only: [:create, :new]

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.fetch_only_info.all
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
  end

  # GET /submissions/1/download
  def download
    @submission = Submission.find(params[:id])
    fname = @submission.article.name + '-' + @submission.kind_short_name
    content_type = @submission.content_type
    disposition = if content_type == 'application/pdf'
                    :inline
                  else
                    :attachment
                  end

    if @submission.file_path.nil?
      send_data @submission.file,
                :filename => fname,
                :type =>  content_type,
                :disposition => disposition
    else
      send_file @submission.file_path,
                :filename => fname,
                :type =>  content_type,
                :disposition => disposition
    end
  end

  # PUT /submissions/new
  # GET /submissions/new/1
  def new
    @submission = Submission.new
    if params[:article_id] == nil
      @submission.article_id = submission_params[:article_id]
    else
      @submission.article_id = params[:article_id]
    end
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    content = submission_params.dup

    param_file = submission_params[:file]
    if param_file != nil
      content[:content_type] = param_file.content_type
#     content[:file_name] = param_file.original_filename
      if store_in_file?(param_file)
        content[:file] = param_file.read(16)
        @submission = Submission.new(content)
        @submission.file_path =
          store_in_file(submission_params[:article_id],
                        submission_params[:kind],
                        param_file.path)
      else
        content[:file] = param_file.read
        @submission = Submission.new(content)
        @submission.file_path = nil
      end
    end

    send_notification
    respond_to do |format|
      if @submission.save
        format.html { redirect_to @submission, notice: 'Submission was successfully created.' }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    content = submission_params.dup

    param_file = submission_params[:file]
    if param_file != nil
      if @submission.file_path.nil?
        if store_in_file?(param_file)
          data = param_file.read(16)
          @submission.file = data
          content[:file] = data
          @submission.file_path =
            store_in_file(@submission.article_id.to_s,
                          submission_params[:kind],
                          param_file.path)
        else
          data = param_file.read
          @submission.file = data
          content[:file] = data
          @submission.file_path = nil
        end
      else
        File.delete(@submission.file_path)
        @submission.file_path =
          store_in_file(@submission.article_id.to_s,
                        submission_params[:kind],
                        param_file.path)
      end
      @submission.content_type = param_file.content_type
      content[:content_type] = param_file.content_type
      # @submission.save
    end

    send_notification
    respond_to do |format|
      if @submission.update(content)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def send_notification
      if @submission != nil && @submission.is_camera_ready?
        NotifyMailer.send_to_notify(@submission.article,
                                    @submission.kind_name).deliver_now
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_submission_for_owner
      @submission = Submission.find(params[:id])
      unless is_owner?(@submission.article)
        @submission = nil
        force_admin_login
      end
    end

    def set_submission
      if logged_in?
        @submission = Submission.fetch_only_info.find(params[:id])
      else
        force_login
      end
    end

    def set_submission_for_download
      if logged_in?
        @submission = Submission.find(params[:id])
      else
        force_login
      end
    end

  def store_in_file?(f)
    if f.size > 10.megabyte
      true
    else
      path = f.path
      not (path.end_with?('.pdf') || path.end_with?('.doc') ||
           path.end_with?('.zip'))
    end
  end

  def store_in_file(id, kind, path)
    name = Submission::DATA_FILE + id + '-' + kind + File.extname(path)
    unique = 0
    while File.exist? name do
      name = Submission::DATA_FILE + id + '-' + kind +
        '-' + unique.to_s + File.extname(path)
      unique += 1
    end
    File.rename(path, name)
    name
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def submission_params
      params.require(:submission).permit(:article_id, :created_at, :kind, :file, :memo)
  end
end
