# This method navigates to the QPP home page
Given(/^User visit QPP home page$/) do

  visit_page Home_Page
end

# This method navigates to the credentials page in QPP
And(/^User click sign in link on the top right of the page$/) do

end


#This method navigates to the view progress page
And(/^User click view progress$/) do
  sleep 2
  @browser.link(:xpath => "/html/body/app-root/main/app-side-nav/div/aside/div/nav/ul/li[1]/a").when_present.click
  sleep 4
end

#StickySearchBox.Feature
#This method performs operations on the resulting Benelist
And(/^User checks that the search box is visible while scrolling$/) do
  puts "Start Search box visible while scrolling check"
  search_input = @browser.text_field(:xpath, $BENE_SEARCH_BY_MEASURE_BOX_PATH)
  sleep 4

  #Assert that searchbox is visible
  expected_value = search_input.visible?
  expect(expected_value).to be true
  if  expected_value == true
    puts "Search box is visible Before Scrolling"
  end

end

#SearchBoxExists.Feature
#This method performs operations on the resulting Benelist
And(/^User checks that the search box is visible$/) do
  puts "Stsrt Search box visible check"
  search_input = @browser.text_field(:xpath, $BENE_SEARCH_BY_MEASURE_BOX_PATH)
  sleep 4

  #Assert that searchbox is visible
  expected_value = search_input.visible?
  expect(expected_value).to be true
  if  expected_value == true
    puts "Search box is visible"
  end
end

Given(/^User selects the View Reports tab in the left hand navigation bar.$/) do
  sleep 5
   @browser.link(text: "View Reports").wait_until_present.click

end

Given(/^User navigates to the Activity Log report page$/) do
  @browser.link(aria_label: "View Activity Log Report").wait_until_present.click
end

Given(/^User navigates to the Measure Rates report page$/) do
  @browser.link(aria_label: "View Measure Rates Report").wait_until_present.click
end

Given(/^User clicks on 'Select Date Range' dropdown$/) do
  @browser.button(aria_label: "Choose an option to filter by date").wait_until_present.click
end

Given(/^User enters (.*) in Activity Log beginning date range$/) do |arg|
  @browser.text_field(id:"custom-start-date").set arg
end

Given(/^User enters (.*) in Activity Log ending date range$/) do |arg|
  @browser.text_field(id:"custom-end-date").set arg
end
