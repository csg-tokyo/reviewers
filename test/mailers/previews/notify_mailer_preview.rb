# Preview all emails at http://localhost:3000/rails/mailers/notify_mailer
class NotifyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notify_mailer/send_to_notify
  def send_to_notify
    NotifyMailer.send_to_notify
  end

end
