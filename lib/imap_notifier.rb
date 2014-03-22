require 'yaml'
require 'net/imap'
require 'highline/import'

require 'imap_notifier/version'
require 'imap_notifier/config'
require 'imap_notifier/base'

MAX_MAIL    = 5 # Max new mails mentioned before they
                # are grouped together
SLEEP       = 30
ERRFILE     = File.expand_path('/tmp/imap_notifier.log')
DEBUGFILE   = '/tmp/imap_notifier.debug'
PIDFILE     = '/tmp/imap_notifier.pid'
IMAP_SERVER = "imap.gmail.com" # could be anything with tweaks

case RUBY_PLATFORM
when /darwin-?([1][2-9]|[2-9]\d)\./
  # darwin >= 12
  require 'imap_notifier/notifier'
when /darwin-?(\d|[1][01])\./
  # darwin < 12
  require 'imap_notifier/growler'
when /linux/
  require 'imap_notifier/libnotify'
else
  raise "You must be running Mac OS X for imap_notifier to work!"
end
