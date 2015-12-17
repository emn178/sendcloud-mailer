require "action_mailer"
require "sendcloud-mailer/version"
require "sendcloud-mailer/base"

module SendcloudMailer
  ActionMailer::Base.add_delivery_method :sendcloud, Base
end
