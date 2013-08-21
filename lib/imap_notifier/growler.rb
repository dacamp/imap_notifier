require 'ruby-growl'

class IMAP_Notifier::Alert < Growl
  def initialize
    super("localhost", ::IMAP_Notifier::VERSION)
  end

  def alert(title, body)
    add_notification ::IMAP_Notifier::VERSION
    notify ::IMAP_Notifier::VERSION, title, body
  end

end
