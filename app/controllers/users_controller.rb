class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_user_by_admin, only: [:destroy]
  before_action :read_user_by_admin, only: [:index, :new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:email)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if logged_in_as_admin?
        params.require(:user).permit(:name, :email, :affiliation,
                                     :admin, :active, :guest_editor,
                                     :password, :password_confirmation)
      else
        params.require(:user).permit(:name, :email, :affiliation,
                                     :password, :password_confirmation)
      end
    end

    # Use callbacks to share common setup or constraints between actions.

    def set_user
      set_user_if(logged_in_as?(params[:id]) || logged_in_as_admin?,
                  " as an appropriate user.")
    end

    def set_user_by_admin
      set_user_if(logged_in_as_admin?, " as an administrator.")
    end

    def set_user_if(allowed, msg)
      if allowed
        @user = User.find(params[:id])
      else
        flash[:danger] = "Please log in" + msg
        redirect_to login_url
      end
    end

    def read_user_by_admin
      unless logged_in_as_admin?
        flash[:danger] = "Please log in as an administrator."
        redirect_to login_url
      end
    end
end
