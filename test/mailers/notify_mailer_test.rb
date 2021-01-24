require 'test_helper'

class NotifyMailerTest < ActionMailer::TestCase
  test "send_to_notify" do
    mail = NotifyMailer.send_to_notify
    assert_equal "Send to notify", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
