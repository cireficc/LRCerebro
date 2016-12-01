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
      row  = results.first
      user = User.find_or_initialize_by(username: username)

      if user.new_record?
        user.update!({
          first_name: result[:givenname].first,
          last_name:  result[:sn].first,
        })
      end

      success!(user)
    else
      fail(:invalid_login)
    end
  end
end
