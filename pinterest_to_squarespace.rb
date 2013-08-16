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

element = driver.find_element(:class, 'customer-login')
element.click
element.send_keys squarespace.user
element = driver.find_element(:id, 'yui_3_10_1_1_1376644582512_573')
element.click
element = driver.find_element(:id, 'field-input')



