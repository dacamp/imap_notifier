require 'terminal-notifier'

class IMAP_Notifier::Alert
  def self.remove
    return if (msgs = TerminalNotifier.list).nil?
    msgs.map{ |a| TerminalNotifier.remove a[:group]  }
  end

  def alert(body, opts={})
    opts[:title] ||= self.class.name
    TerminalNotifier.notify(body, opts.merge({:sender => 'com.apple.Mail'}))
  end
end
