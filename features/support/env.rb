require 'watir-webdriver'

AfterConfiguration do
  $env = ENV["env"]
  $config = YAML.load_file("#{Dir.getwd}/features/test-data/environment-#{$env}.yml")
  $browser = ENV["browser"].nil? ? "firefox" : ENV["browser"]
end

Before do
  case $browser
    when "chrome" then $B = Watir::Browser.new :chrome
    when "firefox" then
      # profile = Selenium::WebDriver::Firefox::Profile.new
      # profile.native_events = false :profile => profile
      $B = Watir::Browser.new :firefox
  end
  $B.driver.manage.window.maximize
end

After do
  $B.close
end

