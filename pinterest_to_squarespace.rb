# this daemon checks for new pins and then posts them to a squarespace
# blog

require 'yaml'
require 'pry'
require "selenium-webdriver"
require 'simple-rss'
require 'open-uri'
require 'dm-sqlite-adapter'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-constraints'
require 'dm-migrations'
require 'data_mapper'
require 'cgi'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, 'sqlite:pins.db')

class Pin
  include DataMapper::Resource
  property :id,         Serial    # An auto-increment integer key
  property :url,      Text    # A varchar type string, for
  property :board, String
end

DataMapper.finalize
DataMapper.auto_upgrade!


data = YAML.load_file('data.yml')
pinterest_boards = data["pinterest_boards"]
squarespace = data["squarespace_login"]
loginurl = squarespace["login_url"]

$driver = Selenium::WebDriver.for :chrome
$driver.navigate.to loginurl
$driver.navigate.to "http://thingsihaveseen.squarespace.com/display/configuration/PostManagement"


# define what a new entry is
def is_new?(pin)
  Pin.count(:url => pin[:link]) == 0
end

# save url to list of pinterest pins already blogged
def save_new(pin, board_url)
  begin
    newPin = Pin.new
    newPin.url = pin[:link]
    newPin.board = board_url
    newPin.save
  rescue Exception => e
    puts e
  end
end

def publish_pin(title, content)
  # click "new entry" button
  wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
  wait.until { $driver.find_element(:css => '#sectionDescription #true') }
  element = $driver.find_element(:css => '#sectionDescription #true')
  element.click

  # switch to editor iframe
  wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
  wait.until { $driver.find_element(:css => '#configuration-container-frame') }
  $driver.switch_to().frame "configuration-container-frame"

  sleep(4)
  # switch to html mode
  wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
  wait.until { $driver.find_element(:css => '#mode_html') }
  confirmbox = $driver.execute_script("document.getElementById('mode_html').click()")

  sleep(4)
  # enter blog entry title
  wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
  wait.until { $driver.find_element(:css => '#titleData') }
  element = $driver.find_element(:css => '#titleData')
  element.clear #click to erase current text content
  element.send_keys title

  # enter blog entry content
  wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
  wait.until { $driver.find_element(:css => 'textarea#body') }
  element = $driver.find_element(:css => 'textarea#body')
  element.click #click to initialize editiable area
  element.send_keys CGI.unescapeHTML(content.to_s)

  # switch back to default context
  $driver.switch_to.default_content

  # click save and publish
  wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
  wait.until { $driver.find_element(:css => '#inlineSaveTarget') }
  element = $driver.find_element(:css => '#inlineSaveTarget')
  element.click
end


loop do
  # find new entries
  # add them
  data["pinterest_boards_jollybox"].each do |board_url|
    open(board_url) do |rss|
      begin
        feed = SimpleRSS.parse open(rss)
      rescue Exception => e
        puts e
      end
      feed.items.each do |pin|
        if is_new?(pin)
          publish_pin(pin[:title], pin[:description])
          save_new(pin, board_url)
        end
      end
    end
  end
  
  puts "Finished migration at #{Time.now}"
  sleep(1)
end







