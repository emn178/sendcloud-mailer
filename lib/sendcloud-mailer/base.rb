require 'rest-client'

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
        :cc => cc,
        :bcc => bcc,
        :subject => mail.subject,
        :html => html,
        :plain => plain,
        :attachments => attachments
      }
      params.delete_if { |k, v| v.nil? }

      result = RestClient.post( 'http://api.sendcloud.net/apiv2/mail/send', params )
      json = JSON.parse(result.force_encoding('UTF-8'))
      error(json) unless json["result"]
      unless @file.nil?
        File.unlink(@file.path) rescue nil
      end
    end

    private

    def error(message)
      ActionMailer::Base.logger.error(message) unless ActionMailer::Base.logger.nil?
    end

    def from
      @mail.header.fields.find{|f| f.name == "From"}.value 
    end

    def to
      addresses 'To'
    end

    def cc
      addresses 'Cc'
    end

    def bcc
      addresses 'Bcc'
    end

    def addresses(name)
      result = @mail.header.fields.find { |f| f.name == name }
      unless result.nil?
        addresses = result.address_list.addresses
        addresses.join(';')
      end
    end

    def html
      @mail.html_part ? @mail.html_part.body.decoded : nil
    end

    def plain
      @mail.multipart? ? (@mail.text_part ? @mail.text_part.body.decoded : nil) : @mail.body.decoded
    end

    def attachments
      return nil if @mail.attachments.length == 0

      @mail.attachments.each do | attachment |
        filename = attachment.filename
        # sendcloud api can only single file
        @file = File.new(File.join(Dir.tmpdir, filename), 'w+b')
        @file.write(attachment.body.decoded)
        return @file
      end
    end
  end
end
