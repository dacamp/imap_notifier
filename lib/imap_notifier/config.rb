class IMAP_Notifier
  def config(opts={})
    read_conf opts
    @imap_server = opts[:server] || IMAP_SERVER
    @domain      = opts[:domain] || @imap_server.split('.').pop(2).join('.')
    @user        = "#{opts[:user]}@#{@domain}"
    $key_name    = opts[:key_name] || false
    $key_account = opts[:key_account] || false
    if $key_name && $key_account
      @password  = keychain_access || get_password
    else
      @password  = opts[:password] || get_password
    end
    @folders     = mbox_conf opts[:folders] || ['INBOX']
    @debug       = opts[:debug] || false
    @max_mail    = opts[:max]   || MAX_MAIL
  end

  private
  def mbox_conf ary
    Hash[ary.map{ |f| [f,Array.new] }]
  end

  private
  def keychain_access
    key = get_keychain
    if key == ""
      return nil
    end
    return key.chomp
  end

  private
  def get_keychain
    key = %x{security find-internet-password -w -a #{$key_account} -s #{$key_name}}
  end

  private
  def get_password(prompt="Enter Password: ")
    ask(prompt) { |q| q.echo = false }
  end

  def read_conf opts
    file = File.expand_path("~/.imap_notifier")
    return if ! File.exists? file
    ensure_perms file
    YAML.load(File.open(file)).each do |k,v|
      opts[k.to_sym] ||= v
    end
    opts[:user] ||= ENV['USER']
  end

  def ensure_perms file
    m =  sprintf("%o", File.stat(file).mode).split('').last(3).join().to_i
    return if m.eql? 600
    warn "#{file} permissions should be set to 600 #{m}"
    exit 1
  end
end

