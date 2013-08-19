# this daemon checks for new pins and then posts them to a squarespace
# blog

require 'yaml'
require 'pry'
require "selenium-webdriver"

data = YAML.load_file('data.yml')
pinterest_boards = data["pinterest_boards"]
squarespace = data["squarespace_login"]



driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://tony-seing-37e6.squarespace.com/sharer?src=bm&v=2&u=https%3A%2F%2Ftony-seing-37e6.squarespace.com%2Fconfig%23collectionId%3D520d9df3e4b0f0270824e7d4%26module%3Dcontent%26settings-subpanelName%3Dsite-settings&t=Squarespace%20-%20Configuration&cid=520d9df3e4b0f0270824e7d4&mid=520d97f4e4b098edc0ee1039&sel="


# find username field

wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '.dialog-field-email .field-input') }
element = driver.find_element(:css, '.dialog-field-email .field-input')


# enter username
element.send_keys squarespace["username"]

# select password field
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '.dialog-field-password .field-input') }
element = driver.find_element(:css, '.dialog-field-password .field-input')

# enter password
element.send_keys squarespace["password"]

# click login button
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:class => 'saveAndClose') }
element = driver.find_element(:class, 'saveAndClose')
element.click


# now enter new blog entry

# enter blog entry title
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '.name-title  input') }
element = driver.find_element(:css => '.name-title input')
element.clear #click to erase current text content
element.send_keys "test title"



# enter blog entry content
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '.sqs-placeholder') }
element = driver.find_element(:css => '.sqs-placeholder')
element.click #click to initialize editiable area
binding.pry
element.send_keys "test content"
binding.pry

# click save and publish
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '.saveAndPublish') }
element = driver.find_element(:css => '.saveAndPublish')
element.click

