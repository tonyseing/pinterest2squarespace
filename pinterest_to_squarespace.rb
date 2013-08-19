# this daemon checks for new pins and then posts them to a squarespace
# blog

require 'yaml'
require 'pry'
require "selenium-webdriver"

data = YAML.load_file('data.yml')
pinterest_boards = data["pinterest_boards"]
squarespace = data["squarespace_login"]

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "http://www.squarespace.com"

# click login link
element = driver.find_element(:class, 'customer-login')
element.click



# wait for a specific element to show up
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
wait.until { driver.find_element(:id => "yui_3_10_1_1_1376894047556_573") }

# find username field
element = driver.find_element(:id, 'yui_3_10_1_1_1376894047556_573')

# enter username
element.send_keys squarespace["user"]

# select password field
element = driver.find_element(:id, 'yui_3_10_1_1_1376682320435_632')

# enter password
element.send_keys squarespace["password"]

# click login button
element = driver.find_element(:class, 'saveAndClose')
element.click


