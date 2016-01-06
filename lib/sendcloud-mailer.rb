require "action_mailer"
require "sendcloud-mailer/version"
require "sendcloud-mailer/base"
require "sendcloud-mailer/interceptor"

module SendcloudMailer
  ActionMailer::Base.add_delivery_method :sendcloud, Base
end
