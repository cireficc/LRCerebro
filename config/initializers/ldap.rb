if Rails.env.production?
  Cerebro.ldap = 
    Net::LDAP.new({
      host: Figaro.env.ldap_host!,
      port: 636,
      auth: {
        method: :simple,
        username: Figaro.env.ldap_username!,
        password: Figaro.env.ldap_password!,
      },
      encryption: :simple_tls,
    })

  if !Cerebro.ldap.bind
    raise ArgumentError, "Invalid LDAP credentials"
  end
end
