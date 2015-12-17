module SendcloudMailer
  class Base
    attr_accessor :settings

    def initialize(settings)
      self.settings = settings
    end

    def deliver!(mail)
      @mail = mail

      params = {
        :apiUser => settings[:api_user],
        :apiKey => settings[:api_key],
        :from => from,
        :to => to,
        :subject => mail.subject,
        :html => html,
        :plain => plain
      }

      result = Net::HTTP.post_form(URI.parse("http://api.sendcloud.net/apiv2/mail/send"), params)
      json = JSON.parse(result.body.force_encoding('UTF-8'))
      ActionMailer::Base.logger.error(json) unless json["result"] && !ActionMailer::Base.logger.nil?
    end

    def from
      @mail.header.fields.find{|f| f.name == "From"}.value 
    end

    def to
      addresses = @mail.header.fields.find{|f| f.name == "To"}.address_list.addresses
      addresses.join(';')
    end

    def html
      @mail.html_part ? @mail.html_part.body.decoded : nil
    end

    def plain
      @mail.multipart? ? (@mail.text_part ? @mail.text_part.body.decoded : nil) : @mail.body.decoded
    end
  end
end
