# sendcloud-mailer

[![Build Status](https://api.travis-ci.org/emn178/sendcloud-mailer.png)](https://travis-ci.org/emn178/sendcloud-mailer)
[![Coverage Status](https://coveralls.io/repos/emn178/sendcloud-mailer/badge.svg?branch=master)](https://coveralls.io/r/emn178/sendcloud-mailer?branch=master)

An Action Mailer delivery method for SendCloud email service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sendcloud-mailer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendcloud-mailer

## Usage

Set up delivery method and SendCloud settings in you rails config, eg. `config/environments/production.rb`
```Ruby
config.action_mailer.delivery_method = :sendcloud
config.action_mailer.sendcloud_settings = {
  :api_user => 'USER',
  :api_key => 'KEY'
}
```
If you use SMTP, you can add this interecptor to fix the problem that SendCloud does not accept <HTML> tag.
```Ruby
ActionMailer::Base.register_interceptor(SendcloudMailer::Interceptor)
```

## Notice
This gem is to send email by using SendCloud API, but the API can only support single attachment.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Contact
The project's website is located at https://github.com/emn178/sendcloud-mailer  
Author: Chen, Yi-Cyuan (emn178@gmail.com)
