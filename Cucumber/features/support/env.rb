require 'rubygems'
require 'rspec'
require 'rspec/expectations'
require 'require_all'
require 'rubygems'
# require './lib/aes_strict'
# require './lib/user_util'
require './lib/selenium_util'
require 'time'
require 'uri'
require 'net/http'
require 'json'
#require 'json_spec/cucumber'
#require 'page-object'
#require 'page-object/page_factory'
require 'test/unit/assertions'
require 'watir/element_collection'
require 'net/http/post/multipart'
require 'jsonpath'

BrowserUtil.check_grid

#World(PageObject::PageFactory)

def is_feature_turned_on
  (ENV['IS_FEATURE_TURNED_ON']||="true").downcase
end

def reporting_year
  (ENV['REPORTING_YEAR']||="2017").to_s
end
