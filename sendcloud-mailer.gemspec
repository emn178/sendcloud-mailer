# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendcloud-mailer/version'

Gem::Specification.new do |spec|
  spec.name          = "sendcloud-mailer"
  spec.version       = SendcloudMailer::VERSION
  spec.authors       = ["Chen, Yi-Cyuan"]
  spec.email         = ["emn178@gmail.com"]

  spec.summary       = %q{An Action Mailer delivery method for SendCloud email service.}
  spec.description   = %q{An Action Mailer delivery method for SendCloud email service.}
  spec.homepage      = "https://github.com/emn178/sendcloud-mailer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionmailer"
  spec.add_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
