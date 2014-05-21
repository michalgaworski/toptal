require 'watirsome'

class LoginPage
  include Watirsome

  text_field :email, id: 'user_email'
  text_field :pass, id: 'user_password'
  input :login, value: 'Login'

  def login(user, pass)
    email_text_field.set user
    pass_text_field.set pass
    login_input.click
  end

end