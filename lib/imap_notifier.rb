require 'yaml'
require 'net/imap'
require 'highline/import'

require 'imap_notifier/version'
require 'imap_notifier/config'
require 'imap_notifier/base'

MAX_MAIL    = 5 # Max new mails mentioned before they
                # are grouped together
SLEEP       = 30
ERRFILE     = File.expand_path('~/Desktop/imap_notifier.log')
DEBUGFILE   = '/tmp/imap_notifier.debug'
PIDFILE     = '/tmp/imap_notifier.pid'
IMAP_SERVER = "imap.gmail.com" # could be anything with tweaks

if `uname`.strip == 'Darwin'
  if (OSX_VERSION = `sw_vers -productVersion`.strip) >= '10.8'
    require 'imap_notifier/notifier'
  else
    require 'imap_notifier/growler'
  end
else
  raise "You must be running Mac OS X for imap_notifier to work!"
end
