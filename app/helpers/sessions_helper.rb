module SessionsHelper
  def log_in(user)
    session[:cur_user_id] = user.id
    session[:cur_user_email] = user.email.nil? ? "" : user.email
    session[:cur_admin_user] = user.admin
    session[:cur_guest_user] = user.guest_editor
  end

  def current_user
    session[:cur_user_id]
  end

  def current_user_string
    if logged_in? && !session[:cur_user_email].nil?
      session[:cur_user_email]
    else
      ""
    end
  end

  def logged_in?
    !session[:cur_user_id].nil?
  end

  def logged_in_as?(uid)
    logged_in? && session[:cur_user_id] == uid.to_i
  end

  def logged_in_as_oneof?(uids)
    if logged_in?
      cur_id = session[:cur_user_id]
      uids.each do |u|
        if cur_id == u.user_id
          return true
        end
      end
    end
    false
  end

  def logged_in_as_admin?
    logged_in? && session[:cur_admin_user]
  end

  def logged_in_as_guest?
    logged_in? && session[:cur_guest_user]
  end

  def log_out
    session.delete(:cur_user_id)
    session.delete(:cur_user_email)
    session.delete(:cur_admin_user)
    session.delete(:cur_guest_user)
  end
end
