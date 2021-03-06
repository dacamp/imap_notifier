IMAP Notifier
=============

Notification of new, unread email via IMAP using Ruby, [Highline](http://highline.rubyforge.org/doc/), [Net/IMAP](http://ruby-doc.org/stdlib-1.9.3/libdoc/net/imap/rdoc/Net/IMAP.html), and [terminal-notifier](https://github.com/alloy/terminal-notifier)/[ruby-growl](https://github.com/drbrain/ruby-growl).

If you're running Max OSX > 10.8, [terminal-notifier](https://github.com/alloy/terminal-notifier) is required, otherwise [ruby-growl](https://github.com/drbrain/ruby-growl) and [Growl](http://growl.info/) is required.

Setup
--------
Configure your .imap_notifier config file in your homedir or specific the flags via the command line.  Your config file must have permissions of 600, thus allowing you to put in your password if you so choose.  The config file is in YAML format and should be read in as a hash.


Example ~/.imap_notifier file

    folders:
     - INBOX
     - Monitoring
     - Commits
     - Team+Status
    user:   'han.solo'
    domain: 'example.org'
    server: 'imap.server.com'
    password: "1H@t3BuG$!"
    max: 10
    pid: /tmp/imap_notifier.1.pid  # defaults to /tmp/imap_notifier.pid set this to initialize multiple imap_notifier instances
    ignore_exit_code: true  #defaults to false. When true, returns 0 instead of 1 on existing pidfile exit


For Keychain Access support, specify the keychain item name and account in .imap_notifier.  The item must be designated an 'Internet password' in Keychain Access.

    key_name:    'keychain.name.com'
    key_account: 'han.solo@keychain-account.com'

For [pass](http://www.passwordstore.org/) support, specify the pass-name.

    pass: 'han.solo'

For [1pass](https://github.com/georgebrock/1pass) support, specify the item and keychain path (if not ``~/Dropbox/1Password.agilekeychain``).

    onepass:  'han.solo'
	one_path: '/Volumes/passwords/1Password.agilekeychain'


Usage
---------

    $ ./bin/imap_notifier   -h
      Usage: imap_notifier [OPTIONS]
      Options:
       -h, --help                      Display this message
       -V, --version                   Display 'IMAP Notifier 0.2.0' and exit
       -v, --debug                     Write debug output into /tmp/imap_notifier.debug
       -f, --file FILE                 Read configuration file. [DEFAULT: ~/.imap_notifier]
       -s, --server STR                Specify imap server. [Default: imap.gmail.com]
       -d, --domain STR                Specify email domain. [Default: gmail.com]
       -u, --user STR                  Specify user login. [Default: ENV['USER']]
       -m, --max INT                   Max mail mentioned before grouping them together. [Default: 5]
       -k, --kill                      Kill currently running IMAP Notifier process with SIGINT


Tips
------

* User name is pulled from your environment via ```ruby ENV['USER'] ```
* If the root domain of your IMAP server is the same as your email domain (i.e. imap._gmail.com_ IS the same as user@_gmail.com_) then you only need to specify the IMAP server.
