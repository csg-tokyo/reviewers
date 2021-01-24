class NotifyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notify_mailer.send_to_notify.subject
  #
  def send_to_notify(article, status)
    @article = article
    @status = status
    to_addr = ENV['MAIL_ADDR']
    to_addr = 'root@localhost' if to_addr.nil?
    mail to: to_addr, subject: '[Review] ' + @article.name
  end
end
