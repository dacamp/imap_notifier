source 'https://rubygems.org'

# Specify your gem's dependencies in imap_notifier.gemspec
gemspec

def is_mnt_lion?
   @lion ||=  (RUBY_PLATFORM.match /(\d+)\.\d+\.\d+$/)[0].to_i >= 12
end

gem 'terminal-notifier', :require => is_mnt_lion?
gem 'ruby-growl', :require => is_mnt_lion?

gem 'highline'