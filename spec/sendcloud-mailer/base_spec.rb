require 'spec_helper'

describe SendcloudMailer::Base do
  after {
    next if delivered
    stub = stub_request(:post, "http://api.sendcloud.net/apiv2/mail/send")
      .to_return(:body => body)
    stub.with(:body => post) unless post.nil?
    unless with.nil?
      stub.with &with
    end
    mail.deliver_now
  }
  let(:delivered) { false }
  let(:with) { nil }
  let(:mail) { ActionMailer::Base.mail(message) }
  let(:post) { nil }
  let(:body) { "{\"result\":true}" }
  let(:message) { {:from => 'emn178@gmail.com', :to => 'user@example.com', :subject => 'Title', :body => 'Test'} }

  context "when failed" do
    context "with logger" do
      let(:body) { "{\"result\":false,\"statusCode\":40005,\"message\":\"\xE8\xAE\xA4\xE8\xAF\x81\xE5\xA4\xB1\xE8\xB4\xA5\",\"info\":{}}" }
      it { expect(ActionMailer::Base.logger).to receive(:error).once }
    end

    context "without logger" do
      before { allow(ActionMailer::Base.logger).to receive(:nil?).and_return(true) }
      let(:body) { "{\"result\":false,\"statusCode\":40005,\"message\":\"\xE8\xAE\xA4\xE8\xAF\x81\xE5\xA4\xB1\xE8\xB4\xA5\",\"info\":{}}" }
      it { expect(ActionMailer::Base.logger).not_to receive(:error) }
    end
  end

  context "when successful" do
    it { expect(ActionMailer::Base.logger).not_to receive(:error) }
  end

  context "with single to" do
    let(:post) { 
      {
        "apiKey"=>"KEY", 
        "apiUser"=>"USER", 
        "from"=>"emn178@gmail.com",
        "plain"=>"Test", 
        "subject"=>"Title", 
        "to"=>"user@example.com"
      } 
    }
    it { expect(ActionMailer::Base.logger).not_to receive(:error) }
  end

  context "with multiple to" do
    let(:post) { 
      {
        "apiKey"=>"KEY", 
        "apiUser"=>"USER", 
        "from"=>"emn178@gmail.com",
        "plain"=>"Test", 
        "subject"=>"Title", 
        "to"=>"user@example.com;user2@example.com"
      } 
    }
    let(:message) { {:from => 'emn178@gmail.com', :to => ['user@example.com', 'user2@example.com'], :subject => 'Title', :body => 'Test'} }
    it { expect(ActionMailer::Base.logger).not_to receive(:error) }
  end

  context "with html" do
    let(:mail) { TestMailer.hello }
    let(:post) { 
      {
        "apiKey"=>"KEY", 
        "apiUser"=>"USER", 
        "from"=>"emn178@gmail.com",
        "html"=>"<h1>Hello!</h1>",
        "plain"=>"Hello!", 
        "subject"=>"Title", 
        "to"=>"user@example.com"
      }
    }
    it { expect(ActionMailer::Base.logger).not_to receive(:error) }
  end

  context "with cc" do
    let(:message) { 
      {
        :from => 'emn178@gmail.com',
        :to => 'user@example.com',
        :subject => 'Title',
        :body => 'Test',
        :cc => 'user2@example.com'
      }
    }
    let(:post) { 
      {
        "apiKey"=>"KEY", 
        "apiUser"=>"USER", 
        "from"=>"emn178@gmail.com",
        "plain"=>"Test", 
        "subject"=>"Title", 
        "to"=>"user@example.com",
        "cc"=>"user2@example.com"
      }
    }
    it { expect(ActionMailer::Base.logger).not_to receive(:error) }
  end

  context "with bcc" do
    let(:message) { 
      {
        :from => 'emn178@gmail.com',
        :bcc => 'user@example.com',
        :subject => 'Title',
        :body => 'Test'
      }
    }
    let(:post) { 
      {
        "apiKey"=>"KEY", 
        "apiUser"=>"USER", 
        "from"=>"emn178@gmail.com",
        "plain"=>"Test", 
        "subject"=>"Title", 
        "bcc"=>"user@example.com"
      }
    }
    it { expect(ActionMailer::Base.logger).not_to receive(:error) }
  end

  context "with attachments" do
    let(:mail) { TestMailer.attachment }

    context "and save successful" do
      let(:with) { 
        Proc.new { |request|
          request.body =~ /--\d+\r\nContent-Disposition: form-data; name=\"apiUser\"\r\n\r\nUSER\r\n--\d+\r\nContent-Disposition: form-data; name=\"apiKey\"\r\n\r\nKEY\r\n--\d+\r\nContent-Disposition: form-data; name=\"from\"\r\n\r\nemn178@gmail.com\r\n--\d+\r\nContent-Disposition: form-data; name=\"to\"\r\n\r\nuser@example.com\r\n--\d+\r\nContent-Disposition: form-data; name=\"subject\"\r\n\r\nTitle\r\n--\d+\r\nContent-Disposition: form-data; name=\"plain\"\r\n\r\nTest\r\n--\d+\r\nContent-Disposition: form-data; name=\"attachments\"; filename=\"sample.png\"\r\nContent-Type: image\/png\r\n\r\n\r\n--\d+--\r\n/
        }
      }
      it { expect(ActionMailer::Base.logger).not_to receive(:error) }
    end

    context "and save failed" do
      let(:delivered) { true }
      before { allow_any_instance_of(File).to receive(:write).and_raise('Mock') }
      it { expect{ mail.deliver_now }.to raise_error('Mock') }
    end
  end
end
