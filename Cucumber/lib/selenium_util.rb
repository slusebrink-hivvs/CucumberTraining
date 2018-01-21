require 'selenium-webdriver'
require 'watir'
require 'socket'
require 'timeout'
require 'rbconfig'

ENV['DOWNLOAD_FOLDER'] = Dir.home+"/Downloads" if ENV['DOWNLOAD_FOLDER'].nil?

CONTENT_TYPES = "audio/aac,application/x-abiword,application/octet-stream,video/x-msvideo,application/vnd.amazon.ebook,application/octet-stream,application/x-bzip,application/x-bzip2,application/x-csh,text/css,text/csv,application/msword,application/vnd.ms-fontobject,application/epub+zip,image/gif,text/html,image/x-icon,text/calendar,application/java-archive,image/jpeg,application/json,audio/midi,video/mpeg,application/vnd.apple.installer+xml,application/vnd.oasis.opendocument.presentation,,application/vnd.oasis.opendocument.spreadsheet,application/vnd.oasis.opendocument.text,audio/ogg,video/ogg,application/ogg,font/otf,application/pdf,application/vnd.ms-powerpoint,application/x-rar-compressed,application/rtf,application/x-sh,application/x-tar,application/vnd.visio,audio/x-wav,audio/webm,,video/webm,image/webp,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/xml,application/vnd.mozilla.xul+xml,application/zip,audio/video container,video/3gpp,application/x-7z-compressed"

module BrowserUtil

  def self.check_grid()
    if ENV['GRID_HUB'].nil?
      ENV['GRID_HUB'] = 'localhost'
      if !is_port_used?('localhost',4444)
        startHub
        startNode
      else
        puts "assumes Selenium Grid is running locally on port 4444"
      end
    end
  end

  def self.open(bName)

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 600 # seconds.

    case bName
      when 'chrome'
        @caps = Selenium::WebDriver::Remote::Capabilities.chrome()
        prefs = {download:{
            prompt_for_download: false,
            default_directory: ENV['DOWNLOAD_FOLDER']
        }}
        @caps['chromeOptions'] = {:prefs => prefs}
      when 'firefox'
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['browser.download.dir'] = ENV['DOWNLOAD_FOLDER']
        profile['browser.download.folderList'] = 2
        profile['browser.helperApps.neverAsk.saveToDisk'] = CONTENT_TYPES
        profile['browser.helperApps.alwaysAsk.force'] = false
        profile['browser.download.manager.showWhenStarting'] = false
        profile['pdfjs.disabled'] = true
        @caps = Selenium::WebDriver::Remote::Capabilities.firefox(firefox_profile: profile)
      when 'ie'
        @caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer()
    end

    url = "http://"+ENV['GRID_HUB']+":4444/wd/hub"

     browser = Watir::Browser.new(:remote,:http_client => client, :url => url, :desired_capabilities => @caps)
    #@browser.manage.timeouts.implicit_wait = 60 # seconds

    browser.driver.manage.window.maximize
    return browser
  end

  def self.is_port_used?(ip, port)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false
  end

  def self.startHub()
    is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
    if is_windows
      $hub_pid = spawn 'cd ' + Dir.pwd + '\\..\\Selenium\\Server && Run_Selenium_3.8.1_Hub_Localhost.bat'
    else
      $hub_pid = spawn 'cd ' + Dir.pwd + '/../Selenium/Server && ./Hub_Selenium_3.8.1.sh '
      # Hacked up solution. Spawn doesn't appear to return the correct PID on Macs. The correct seems to always be +2
      $hub_pid = $hub_pid + 2
    end
    sleep 5
    puts "Selenium Hub PID: "+$hub_pid.to_s
    Process.detach($hub_pid)
  end

  def self.startNode()
    is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
    if is_windows
      $node_pid = spawn 'cd ' + Dir.pwd + '\\..\\Selenium\\Server && Run_Selenium_3.8.1_Node_Localhost.bat'
      #
    else
      $node_pid = spawn 'cd ' + Dir.pwd + '/../Selenium/Server && ./Node_Selenium_3.8.1.sh'
      # Hacked up solution. Spawn doesn't appear to return the correct PID on Macs. The correct seems to always be +2
      $node_pid = $node_pid + 2
    end
    sleep 5
    puts "Selenium Node PID: "+$node_pid.to_s
    Process.detach($node_pid)
  end
end