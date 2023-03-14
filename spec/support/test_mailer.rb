class TestMailer < ActionMailer::Base
  def hello
    mail(from: 'emn178@gmail.com', to: 'user@example.com', subject: 'Title') do |format|
      format.text { render plain: 'Hello!' }
      format.html { render plain: '<h1>Hello!</h1>' }
    end
  end

  def body
    mail(from: 'emn178@gmail.com', to: 'user@example.com', subject: 'Title',
         delivery_method: :test) do |format|
      format.text { render plain: 'Hello!' }
      format.html { render plain: '<html><head></head><body><h1>Hello!</h1><p>World</p></body></html>' }
    end
  end

  def without_body
    mail(from: 'emn178@gmail.com', to: 'user@example.com', subject: 'Title',
         delivery_method: :test) do |format|
      format.text { render plain: 'Hello!' }
      format.html { render plain: '<h1>Hello!</h1><p>World</p>' }
    end
  end

  def attachment
    attachments['sample.png'] = File.read('spec/fixtures/sample.png')
    attachments['attachment.png'] = File.read('spec/fixtures/attachment.png')
    mail(from: 'emn178@gmail.com', to: 'user@example.com', subject: 'Title', body: 'Test')
  end
end
