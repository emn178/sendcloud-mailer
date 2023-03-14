require 'spec_helper'

describe SendcloudMailer::Interceptor do
  before do
    ActionMailer::Base.register_interceptor(SendcloudMailer::Interceptor)
    mail.deliver_now
  end
  after do
    Mail.unregister_interceptor(SendcloudMailer::Interceptor)
    ActionMailer::Base.deliveries.clear
  end
  subject { ActionMailer::Base.deliveries[0].html_part.body.decoded }

  context 'when body is existed' do
    let(:mail) { TestMailer.body }
    it { should eq "<div>\n<h1>Hello!</h1>\n<p>World</p>\n</div>" }
  end
  context 'when body is not existed' do
    let(:mail) { TestMailer.without_body }
    it { should eq "<div>\n<h1>Hello!</h1>\n<p>World</p>\n</div>" }
  end
end
