module SendcloudMailer
  class Interceptor
    def self.delivering_email(mail)
      html = mail.html_part ? mail.html_part.body.decoded : nil
      return if html.nil?

      html = Nokogiri::HTML(html)
      body = html.xpath('//body')[0]
      body.name = 'div'
      mail.html_part.body = body.to_s
    end
  end
end
