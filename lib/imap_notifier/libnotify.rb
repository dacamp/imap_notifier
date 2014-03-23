require 'libnotify'

class IMAP_Notifier::Alert
  def self.remove
  end

  def alert(body, opts={})
    opts[:title] ||= self.class.name
    Libnotify.show(:body => body, :summary => opts[:title].to_s, :timeout => 5)
  end
end
