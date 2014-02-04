class IMAP_Notifier
  def self.kill_process
    pid = IO.readlines(PIDFILE).first.to_i
    puts "Killing PID: #{pid}"
    Process.kill("SIGINT", pid)
  rescue Errno::ESRCH, Errno::ENOENT => e
    puts "#{e.message} - Exiting..."
  end

  def initialize(opts={})
    config opts
    @notifier = IMAP_Notifier::Alert.new

    pid = fork do
      $stderr.reopen(ERRFILE, 'w')
      at_exit {  self.stop }
      run
    end
    File.open(PIDFILE, 'w') { |f| f.write pid }
  end

  def run
    begin
      @folders.each do |f, ids|
        alert_folder(f, ids)
      end
      sleep SLEEP
    rescue EOFError
      @imap = nil
    rescue Exception => err
      say_goodbye(err.class.to_s) || handle_exception(err)
      exit
    end while true
  end

  def alert_folder(f, ids)
    imap.examine(f)
    unseen    = imap.search(["UNSEEN"])
    unalerted = unseen - ids

    if unalerted.length > @max_mail
      @notifier.alert("#{f}: #{unalerted.length} new mails", :group => f)
    else
      unalerted.each do |msg_id|
        msg = imap.fetch(msg_id, "ENVELOPE")[0].attr["ENVELOPE"]
        next if ids.include?(msg.message_id)
        @notifier.alert("#{f} #{msg.subject}", :title => "Mail from #{msg.sender.first.mailbox}", :group => msg_id)
      end
    end
    @folders[f] = unseen
  end

  def imap
    @imap ||= _imap
  end

  def stop
    IMAP_Notifier::Alert.remove
    File.delete(PIDFILE) if File.exists?(PIDFILE)
  end

  private
  def get_password(prompt="Enter Password: ")
    ask(prompt) { |q| q.echo = false }
  end

  def _imap
    imap = Net::IMAP.new(@imap_server, { :port => 993, :ssl => true } )
    imap.login(@user, @password)
    @notifier.alert("#{@user} connected!", :group => @domain)
    return imap
  end

  def say_goodbye(klass)
    return if !(klass.eql? "Interrupt")
    @notifier.alert("Goodbye!", :group => @domain)
    File.delete(ERRFILE) if File.exists?(ERRFILE)
  end

  def handle_exception(err)
    @notifier.alert(err.message, :title => err.class, :open => "file://#{ERRFILE}")
    warn("#{Time.now} - #{@user}")
    warn("#{err.class}: #{err.message}")
    err.backtrace.map{ |e| warn e }
  end
end
