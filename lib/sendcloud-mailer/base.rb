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
        apiUser: settings[:api_user],
        apiKey: settings[:api_key],
        from: from,
        to: to,
        cc: cc,
        bcc: bcc,
        subject: mail.subject,
        html: html,
        plain: plain,
        attachments: attachments,
        labelId: label_id
      }
      params.delete_if { |_k, v| v.nil? }

      result = RestClient.post('http://api.sendcloud.net/apiv2/mail/send', params)
      json = JSON.parse(result.force_encoding('UTF-8'))
      error(json) unless json['result']
      unless @file.nil?
        begin
          File.unlink(@file.path)
        rescue StandardError
          nil
        end
      end
    end

    private

    def error(message)
      ActionMailer::Base.logger.error(message) unless ActionMailer::Base.logger.nil?
    end

    def from
      @mail.header.fields.find { |f| f.name == 'From' }.value
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
        addresses = result.addresses
        addresses.join(';')
      end
    end

    def html
      if @mail.html_part
        @mail.html_part.body.decoded
      else
        @mail.content_type =~ %r{text/html} ? @mail.body.decoded : nil
      end
    end

    def plain
      if @mail.multipart?
        @mail.text_part ? @mail.text_part.body.decoded : nil
      else
        @mail.content_type =~ %r{text/plain} ? @mail.body.decoded : nil
      end
    end

    def attachments
      return nil if @mail.attachments.length == 0

      @mail.attachments.each do |attachment|
        filename = attachment.filename
        # sendcloud api can only single file
        @file = File.new(File.join(Dir.tmpdir, filename), 'w+b')
        @file.write(attachment.body.decoded)
        return @file
      end
    end

    def label_id
      @mail.header.fields.find { |f| f.name == 'label-id' }.try :value
    end
  end
end
