require 'yaml'
require 'net/imap'
require 'highline/import'

require 'imap_notifier/version'
require 'imap_notifier/config'
require 'imap_notifier/base'


MAX_MAIL    = 5 # Max new mails mentioned before they
                # are grouped together
SLEEP       = 30
ERRFILE     = '/tmp/imap_notifier.err'
DEBUGFILE   = '/tmp/imap_notifier.debug'
PIDFILE     = '/tmp/imap_notifier.pid'
$imap_server = "imap.gmail.com" # could be anything with tweaks

if `uname`.strip == 'Darwin'
  if (OSX_VERSION = `sw_vers -productVersion`.strip) >= '10.8'
    require 'imap_notifier/notifier'
  else
    require 'imap_notifier/growler'
  end
else
  raise "You must be running Mac OS X for imap_notifier to work!"
end
