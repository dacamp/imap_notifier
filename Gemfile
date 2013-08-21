#!/bin/env ruby
source "https://rubygems.org"
ruby "1.9.3"

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
