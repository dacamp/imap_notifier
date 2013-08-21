class IMAP_Notifier
  def config(opts={})
    file = File.expand_path("~#{opts[:user]}/.imap_notifier")
    if File.exists? file
      m =  sprintf("%o", File.stat(file).mode).split('').last(3).join().to_i
      if m != 600
        warn "#{file} must have permissions 0644, not #{m}"
        exit 1
      end
      YAML.load(File.open(file)).each do |k,v|
        opts[k.to_sym] ||= v
      end
    end
    @domain   = opts[:domain] || $imap_server.split('.').pop(2).join('.')
    @user     = "#{opts[:user] || ENV['USER']}@#{@domain}"
    @password = opts[:password] || get_password
    @folders  = Hash[(opts[:folders] || ['INBOX']).map{ |f| [f,Array.new] }]
    @debug    = opts[:debug] || false
    @max_mail = opts[:max] || MAX_MAIL
  end
end
