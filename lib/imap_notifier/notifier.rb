require 'terminal-notifier'

class IMAP_Notifier::Alert
  include TerminalNotifier

  def alert(title,body)
    notify(body, :title => title)
  end
end
