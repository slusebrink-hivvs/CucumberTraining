# This method navigates to the QPP home page
Given(/^User visit QPP home page$/) do
  $BENE_SEARCH_BY_MEASURE_BOX_PATH = "/html/body/app-root/main/main/app-data-entry/div/app-entry-by-measure/div/div/div[1]/div[1]/app-data-entry-search/div/input"
  $BENE_SEARCH_BY_MEASURE_DROP_DOWN_PATH ="/html/body/app-root/main/main/app-data-entry/div/app-entry-by-measure/div/div/div[1]/div[1]/app-data-entry-search/div/typeahead-container/ul"
  $BENE_SEARCH_BY_BENE_BOX_PATH = "/html/body/app-root/main/main/app-data-entry/div/app-entry-by-beneficiary/div/div/div[1]/div[1]/app-data-entry-search/div/input"
  $LAST_ACTIVITY_SPAN_PATH = "//*[@id='landing-progress']/app-submission-window-open/div[1]/div/div/div[1]/div[1]/app-account-status/div/span[1]"
  $LOGIN_CHECK_BOX_PATH = "/html/body/main/div[2]/div[2]/section/div[2]/div[1]/div[2]/form/div[4]/div/label/input"
  $BENE_MEASURE_LIST = @browser.div(xpath:"//*[@id='left-rail-scroll-element']/app-by-bene-card-expanded/div/app-by-bene-card-measure-list/div[2]").elements( :tag_name => "app-by-bene-card-measure" )


  visit_page Home_Page
end

# This method navigates to the credentials page in QPP
And(/^User click sign in link on the top right of the page$/) do
  sleep 1
  on_page Home_Page do |home_page|
    home_page.click_signin
  end
end


#This method clicks on a link with a certain text
And(/^User click web interface link$/) do
  web_interface_lnk = @browser.a(text: "Go to CMS Web Interface")
  sleep 1
  if web_interface_lnk.exists?
    puts" web interface button found on first attempt"
  else
    puts"going into web interface not found loop"
    i = 0
    link_found = false
    while  i < 5 && link_found != true do
      reset_page_for_web_interface_link

      if web_interface_lnk.exists?
        link_found = true
      end
      i += 1
    end
  end
  web_interface_lnk.click
end

# This method allows navigation to the reporting page for Web Interface
And(/^User click on START REPORTING link$/) do
  user_clicks_start_reporting
end

# This method logs a user into QPP with the name and password associated with a particular role
When(/^User logs in to QPPWI with role=(.*)$/) do |role|
  $userObj = UserUtil.get_user("QPPWI",role)

  on_page Login_Page do |login_page|
    uname = AES.decrypt($userObj["uid"],ENV["QPP_AES_KEY"])
    pwd = AES.decrypt($userObj["pwd"],ENV["QPP_AES_KEY"])

    login_page.login_with uname, pwd
  end
end

And(/^User click quality measure link for user tin$/) do
  user_selects_tin
end

#This method navigates to the view progress page
And(/^User click view progress$/) do
  sleep 2
  @browser.link(:xpath => "/html/body/app-root/main/app-side-nav/div/aside/div/nav/ul/li[1]/a").when_present.click
  sleep 4
end

#This method logs the user out of Web Interface
And(/^User logs out$/) do
  on_page QPP_Page do |any_page|
    any_page.signout
  end
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

  #Scroll to the bottom of the screen
  div_with_scroll = @browser.div(id:"left-rail-scroll-element")
  scroll_bottom_script = 'arguments[0].scrollTop = arguments[0].scrollHeight'
  div_with_scroll.browser.execute_script(scroll_bottom_script, div_with_scroll)

  #Assert that searchbox is visible
  expected_value = search_input.visible?
  expect(expected_value).to be true

  if  expected_value == true
    puts "Search box is visible when Scrolling to bottom of list"
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

#This method puts a string into the search box
And(/^User puts "([^"]*)" into Bene Search input$/) do |arg|
  sleep 4
  @browser.text_field(:xpath, $BENE_SEARCH_BY_MEASURE_BOX_PATH).set(arg)

  #assert that the text in search box is entered value
  sleep 2
end

#The initial helper text is "search for a beneficiary".  This check verifies that it is no longer
#part of the search box after the user starts typing
And(/^User verifies that the Helper Text is removed from search box$/) do
  sleep 4
  #Assert that searchbox text is now the input value
  search_input = @browser.text_field(:xpath, $BENE_SEARCH_BY_MEASURE_BOX_PATH)
  #puts "expected_value 1 ="+ search_input.value
  expect(search_input.value).not_to be == "Search for a beneficiary"
  #"Search for a beneficiary
  sleep 2
end

#User is selecting the enter data link on the measures list
And(/^User click on Enter Data for "([^"]*)"$/) do |arg|
  sleep 4
  @browser.div(id:arg+"-card").link(text:"ENTER DATA").click
  sleep 2
end

#User is selecting the enter data link on the measures list
And(/^User click on Enter Data for measure=(.*)$/) do |arg|
  sleep 4
  @browser.div(id:arg+"-card").link(text:"ENTER DATA").click
  sleep 2
end

#This method is the variable version of the select from measure list
And(/^User selects Enter Data for measure=(.*)$/) do |msr|
  sleep 4
  @browser.div(id:msr+"-card").link(text:"ENTER DATA").click
  sleep 2
  puts "Click on Enter Data for "+msr
end

#This method allows users to navigate to the list of all users
#It sometimes fail of the browser is not wide enough to display the link element
And(/^User click on Back to list$/) do
  sleep 5
  if @browser.div(id:"left-rail-scroll-element").span(text:"Back to list").exists?
    @browser.div(id:"left-rail-scroll-element").span(text:"Back to list").click
  else
    sleep 2
    @browser.div(id:"left-rail-scroll-element").span(text:"Back to list").click
  end
end

#This method performs actions on the search dropdown
And(/^User selects first entry in dropdown list$/) do
  puts "Select first entry after dropdown"
  sleep 4
  benelist = @browser.ul(:xpath, $BENE_SEARCH_BY_MEASURE_DROP_DOWN_PATH)
  puts "List has "+ benelist.lis.length.to_s + " items"

  benelist.li(:index => 0).click
end

#This method validates that name and medicareID values are not blank
And(/^User verifies that the list shows name and medicare ID$/) do
  puts "Start verifying dropdown list for valid name and Medicare ID"
  sleep 4
  benelist = @browser.ul(:xpath, $BENE_SEARCH_BY_MEASURE_DROP_DOWN_PATH)
  puts "List has "+ benelist.lis.length.to_s + " items"
  expected_value = true

  benelist.lis.each do |li|
    ##puts 'success' if li.td(:class => 'info_return_description').exists?
    full_name = li.link.span(:index => 0).text
    #first_name =  + full_name.slice(0,full_name.index(" "))
    #last_name = full_name.slice(full_name.index(" "),full_name.length)
    medicare_ID =  + li.link.span(:index => 1).text
    #puts "name and midicare ID" + last_name + "-" + first_name + "-" + medicare_ID
    if full_name.length < 0 || medicare_ID.length <0
      expected_value = false
    end

    #puts "Check the assertion = "+ expected_value.to_s
    #Assert that searchbox is visible
    expect(expected_value).to be true
  end
end

#This method checks to verify the contents of the search dropdown match what is being typed in the
#search box
And(/^User verifies that the drop down reflects the search box parameters$/) do
  puts "start check for dropdown benelist "
  sleep 4
  benelist = @browser.ul(:xpath, $BENE_SEARCH_BY_MEASURE_DROP_DOWN_PATH)
  puts "List has "+ benelist.lis.length.to_s + " items"
  #Expect number of elements in list to be greater than zero
  expect(benelist.lis.length).to be > 0
end

# Verify that matching stirng in the dropdown area is bolded
And(/^User verify that "([^"]*)" on search dropdown name is bolded$/) do  |arg|
  puts "start Bolded check for " + arg
  sleep 4
  benelist = @browser.ul(:xpath, $BENE_SEARCH_BY_MEASURE_DROP_DOWN_PATH)
  puts "List has "+ benelist.lis.length.to_s + " items"

  name_array = Array.new

  benelist.lis.each do |li|
    bolded_text = li.link.span(:index => 0).b.text
    #puts "bolded_text = " + bolded_text

    if bolded_text.downcase == arg.downcase
      puts "Passed Bold text comparing:: " + bolded_text.downcase + " and " + arg.downcase
      expect(bolded_text.downcase).to eq(arg.downcase)
    end
  end
end

#This method concats the first name last name and medicare and comepares , puts them into an array
#and checks to see if they are in alphabetical order
And(/^User verifies that the list shows name and medicare ID in alpha order$/) do
  puts "start alphabet list"
  sleep 4
  benelist = @browser.ul(:xpath, $BENE_SEARCH_BY_MEASURE_DROP_DOWN_PATH)
  puts "List has "+ benelist.lis.length.to_s + " items"

  name_array = Array.new
#This loop creates an array with all of the bene names and their medicare ID
  benelist.lis.each do |li|
    ##puts 'success' if li.td(:class => 'info_return_description').exists?
    full_name = li.link.span(:index => 0).text
    first_name =  + full_name.slice(0,full_name.index(" "))
    last_name = full_name.slice(full_name.index(" "),full_name.length)
    medicare_ID =  + li.link.span(:index => 1).text
    name_array << last_name + "-" + first_name + "-" + medicare_ID
  end

  puts "my array" + name_array.to_s

  previous_name = "none"
  entry_out_of_order = false

#This loops goes through the array and checks to verify that the each entry alphabetically comes before the
#next  in the list.... It returns true is it finds something out of order
  for number in name_array
    #puts "current name is  #{number}"
    if previous_name != "none" && entry_out_of_order == false
      entry_out_of_order =  (previous_name<=> number) > -1
      #puts entry_out_of_order
    end

    previous_name = number
  end

  #Assert that false is returned from the method that checks for alpha order
  expect(entry_out_of_order).to be false
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

def user_selects_tin
  @browser.li(id:$userObj["tin"]).link(class:"group-reporting-btn").wait_until_present(10)
@browser.li(id:$userObj["tin"]).link(class:"group-reporting-btn").click
  sleep 2
end

def user_clicks_start_reporting
  # This method allows navigation to the reporting page for Web Interface
    sleep 2
    @browser.link(text:"Start Reporting").click
end

def user_clicks_account_dashboard
    on_page QPP_Page do |qpp_page|
      qpp_page.click_account_dashboard
    end
end

def reset_page_for_web_interface_link
  puts "In reset page for web inteface loop"
  sleep 3
  @browser.link(:xpath => "//*[@id='qppSidebar']/div/div/a").click
  sleep 1
  user_selects_tin
  sleep 1
  user_clicks_start_reporting
  sleep 4
end


And(/^User deletes all categories data$/) do
  @aci = ACI_Page.new(@browser)
  @aci.delete_all_categories_data
end



And(/^User should see less than (\d+) days popup message$/) do |arg|
  @messages = Validation_Messages_Page.new(@browser)
  @messages.verify_less_than_90_days_message
end

When(/^User click on "([^"]*)" button on popup message$/) do |button_text|
  @browser.button(xpath: "//div[contains(@style,'display: block;')]//button[text()='#{button_text}']").click
end
When(/^User enters performance start date as (.*) and end date as (.*)$/) do |start_date, end_date|
  @aci_page = ACI_Page.new(@browser)
  @aci_page.enter_dates(start_date + "/" + reporting_year, end_date + "/" + reporting_year)
end


Then(/^User views results (.*)$/) do |results|
  @aci_page = ACI_Page.new(@browser)
  @verifi = Verifications.new(@browser)
  providers = @aci_page.get_ehr_providers_list
  @verifi.verify_text(results,providers.count.to_s)
end


When(/^User selects "([^"]*)" result$/) do |provider_nubmer|
  @aci_page = ACI_Page.new(@browser)
  providers = @aci_page.get_ehr_providers_list
  providers[provider_nubmer.to_i-1].scroll
  providers[provider_nubmer.to_i-1].flash
  providers[provider_nubmer.to_i-1].focus
  providers[provider_nubmer.to_i-1].fire_event :click
  sleep 2
  if @browser.element(:xpath=>"(//tr[@class='sg-list-itm'])[1]").exists?
    @browser.element(:xpath=>"(//tr[@class='sg-list-itm'])[1]").flash
    @browser.element(:xpath=>"(//tr[@class='sg-list-itm'])[1]").fire_event :onclick
    sleep 5
  end
end