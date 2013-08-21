class IMAP_Notifier
  def initialize(opts={})
    config opts
    @notifier = IMAP_Notifier::Alert.new

    pid = fork do
      $stderr.reopen(ERRFILE, 'w')
      if @debug
        $stdout.reopen(DEBUGFILE, 'w')
        @notifier.alert("DEBUG MODE ENABLED", "DEBUG LOGFILE: #{DEBUGFILE}")
      end
      run
    end
    File.open(PIDFILE, 'w') { |f| f.write pid }
  end

  def imap
    @imap ||= _imap
  end

  def run
    begin
      @folders.each do |f, ids|
        imap.examine("#{f}")

        p "Mailbox: #{f}" if @debug
        unseen          = imap.search(["UNSEEN"])
        ungrowled       = unseen - ids
        ungrowled_count = ungrowled.length
        p "All unseen mail ids: #{unseen}",
        "All ungrowled mail ids: #{ungrowled}",
        "Ungrowled count: #{ungrowled_count}" if @debug

        if ungrowled_count > @max_mail
          p "New Mail in #{f}!",
          "New: #{ungrowled_count}\nTotal: #{unseen.length}" if @debug
          @notifier.alert("New Mail in #{f}!", "New: #{ungrowled_count}")
        else
          ungrowled.each do |msg_id|
            msg = imap.fetch(msg_id, "ENVELOPE")[0].attr["ENVELOPE"]
            next if ids.include?(msg.message_id)
            p "Growled about #{msg.message_id}" if @debug
            @notifier.alert("Mail from #{msg.sender.first.mailbox}", "#{msg.subject}")
          end
        end
        @folders[f] = unseen
      end
      sleep SLEEP
    rescue Interrupt
      @notifier.alert("Goodbye!", '')
      raise
    rescue EOFError
      imap.login(@user, @password)
    rescue Exception => err
      p "Class: #{err.class}",
      "Message: #{err.message}",
      "See #{ERRFILE} for more info." if @debug
      @notifier.alert(err.class, err.message)

      warn Time.now
      warn @user
      warn $imap_server
      warn err.class
      warn err.message
      err.backtrace.map{ |e| warn e }
      raise
    end while true
  end

  private
  def get_password(prompt="Enter Password: ")
    ask(prompt) { |q| q.echo = false }
  end

  def _imap
    imap = Net::IMAP.new($imap_server, { :port => 993, :ssl => true } )
    imap.login(@user, @password)
    @notifier.alert("User connected to #{@domain}!", "USER: #{@user}")
    return imap
  end
end
