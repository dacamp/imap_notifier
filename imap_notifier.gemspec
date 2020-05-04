# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'imap_notifier/version'

Gem::Specification.new do |spec|
  spec.name          = "imap_notifier"
  spec.version       = IMAP_Notifier::VERSION
  spec.author        = "David Campbell"
  spec.email         = "david@mrcampbell.org"
  spec.description   = %q{Notification of new, unread email via IMAP}
  spec.summary       = %q{Notification of new, unread email via IMAP using Ruby, Highline, Net/IMAP, and terminal-notifier/ruby-growl.

If you're running Max OSX > 10.8, terminal-notifier is required, otherwise ruby-growl and Growl is required.}
  spec.homepage      = "https://github.com/dacamp/imap_notifier"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_dependency "highline"
  spec.add_dependency "ruby-growl"
  spec.add_dependency "terminal-notifier"
end
