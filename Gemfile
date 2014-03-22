source 'https://rubygems.org'

# Specify your gem's dependencies in imap_notifier.gemspec
gemspec

def is_macosx_new?
  @macosx_new ||= RUBY_PLATFORM.match(/darwin-?([1][2-9]|[2-9]\d)\./)
end

def is_macosx?
  @macosx ||= RUBY_PLATFORM.match(/darwin-?(\d|[1][01])\./)
end

def is_linux?
  @linux ||= RUBY_PLATFORM.include? 'linux'
end

gem 'terminal-notifier', :require => is_macosx_new?
gem 'ruby-growl', :require => is_macosx?
gem 'libnotify', :require => is_linux?

gem 'highline'
