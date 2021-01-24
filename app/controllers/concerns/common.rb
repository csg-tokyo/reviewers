module Common extend ActiveSupport::Concern
    def is_admin?
      unless logged_in_as_admin?
        force_admin_login
      end
    end

    def is_user?
      unless logged_in?
        force_login
      end
    end

    def is_owner?(article)
      logged_in_as_oneof?(article.editors) || logged_in_as_admin?
    end

    def force_admin_login
      flash[:danger] = "Please log in as an administrator."
      redirect_to login_url
    end

    def force_login
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
end
