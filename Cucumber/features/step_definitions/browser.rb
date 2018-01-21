Given(/^User opens a (.*) browser$/) do |browser|
  @browser = Watir::Browser.new :chrome
 #@browser = BrowserUtil.open(browser)
end

Given(/^User opens a (.*) browser with directory "([^"]*)"$/) do |browser,directory|
  puts "new directory = "+  Dir.pwd + directory
  ENV['DOWNLOAD_FOLDER'] = Dir.pwd + directory
  @browser = BrowserUtil.open(browser)
end

And(/^User closes browser$/) do
  @browser.quit
  @browser = nil
end

#This method clicks on a link with a certain text
And(/^User click "([^"]*)" link$/) do |arg|
  sleep 4
  @browser.a(text: arg).click
end
#This method clicks on a button with a certain text
And(/^User clicks "([^"]*)" button$/) do |arg|
  @browser.button(text: arg).when_present.click
end