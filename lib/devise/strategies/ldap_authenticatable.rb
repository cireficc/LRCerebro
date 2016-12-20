require "net/ldap"
require "devise/strategies/authenticatable"

# Based on
#   https://github.com/plataformatec/devise/wiki/How-To:-Authenticate-via-LDAP
class Devise::Strategies::LdapAuthenticatable < Devise::Strategies::Authenticatable
  def authenticate!
    username = params[:user][:username]
    password = params[:user][:password]

    results =
      Cerebro.ldap.bind_as({
        base:     "OU=GVSU,DC=ROOTLDS",
        filter:   Net::LDAP::Filter.eq("DisplayName", username),
        password: password,
      })

    if results
      user = User.find_by(username: username)

      if (user)
        success!(user)
      else
        fail('LRCerebro is only accessible to Modern Languages and Literatures faculty and students.')
      end
    else
      fail(:invalid_login)
    end
  end
end
