Given(/^I login to Toptal page as ([^ ]*) user$/) do |usertype|
  $B.goto $config["url"]
  user = $config["#{usertype}-user"]
  pass = $config["#{usertype}-password"]
  front_page = FrontPage.new($B)
  front_page.attempt_login
  login_page = LoginPage.new($B)
  login_page.login(user, pass)
end