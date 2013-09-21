require 'ruby-growl'

class IMAP_Notifier::Alert < Growl
  def self.remove
  end

  def initialize
    super("localhost", ::IMAP_Notifier::VERSION)
  end

  def alert(body, opts={})
    opts[:title] ||= self.class.name
    add_notification ::IMAP_Notifier::VERSION
    notify ::IMAP_Notifier::VERSION, opts[:title], body
  end
end
