class IMAP_Notifier
  def config(opts={})
    read_conf opts
    @imap_server      = opts[:server] || IMAP_SERVER
    @domain           = opts[:domain] || @imap_server.split('.').pop(2).join('.')
    @user             = "#{opts[:user]}@#{@domain}"
    $key_name         = opts[:key_name] || false
    $key_account      = opts[:key_account] || false
    $pass             = opts[:pass] || false
    $one_path         = opts[:one_path] || false
    $onepass          = opts[:onepass] || false
    @password         = opts[:password] || get_password
    @folders          = mbox_conf opts[:folders] || ['INBOX']
    @debug            = opts[:debug] || false
    @max_mail         = opts[:max]   || MAX_MAIL
    @ignore_exit_code = opts[:ignore_exit_code].to_s == 'true'
    @custom_pid       = opts[:pid] || PIDFILE
  end

  private
  def mbox_conf ary
    Hash[ary.map{ |f| [f,Array.new] }]
  end

  private
  def get_password
    if $key_name && $key_account
      key = %x{security find-internet-password -w -a #{$key_account} -s #{$key_name}}
    elsif $pass
      key = %x{pass #{$pass}}
    elsif $onepass
      if $one_path
        key = %x{1pass --path "#{$one_path}" #{$onepass}} 
      else
        key = %x{1pass #{$onepass}} 
      end
    end
    if key.nil? || key.empty?
      key = pass_prompt
    end
    return key.chomp
  end

  private
  def pass_prompt(prompt="Enter Password: ")
    ask(prompt) { |q| q.echo = false }
  end

  def read_conf opts
    config = opts[:config] || "~/.imap_notifier"
    file = File.expand_path(config)
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
