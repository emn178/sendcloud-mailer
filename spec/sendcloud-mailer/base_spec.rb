require 'spec_helper'

describe SendcloudMailer::Base do
  before { 
    mail.deliver_now
  }
  let(:mail) { ActionMailer::Base.mail(message) }

  context "with single to" do
    context "without media_url" do
      let(:message) { {:from => 'emn178@gmail.com', :to => 'user@example.com', :subject => 'Title', :body => 'Test'} }
      it {  }
    end
  end
end
