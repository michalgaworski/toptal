require 'watirsome'

class FrontPage
  include Watirsome

  link :login, text: 'Login'

  public
  def attempt_login
    login_link.click
  end

end