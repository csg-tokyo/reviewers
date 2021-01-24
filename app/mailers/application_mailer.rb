class ApplicationMailer < ActionMailer::Base
  #default from: ENV['MAIL_ADDR']
  from_addr = ENV['MAIL_ADDR']
  from_addr = 'root@localhost' if from_addr.nil?

  default from: from_addr
  layout 'mailer'
end
