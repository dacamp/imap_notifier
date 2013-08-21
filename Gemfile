source 'https://rubygems.org'

# Specify your gem's dependencies in imap_notifier.gemspec
gemspec

if `uname`.strip == 'Darwin'
   if `sw_vers -productVersion`.strip >= '10.8'
     gem 'terminal-notifier'
   else
     gem 'ruby-growl'
   end
else
  raise "You must be running Mac OS X for imap_notifier to work!"
end

gem 'highline'