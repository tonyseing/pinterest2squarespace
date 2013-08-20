# this daemon checks for new pins and then posts them to a squarespace
# blog

require 'yaml'
require 'pry'
require "selenium-webdriver"

data = YAML.load_file('data.yml')
pinterest_boards = data["pinterest_boards"]
squarespace = data["squarespace_login"]
loginurl = squarespace["login_url"]


driver = Selenium::WebDriver.for :chrome
driver.navigate.to loginurl
driver.navigate.to "http://thingsihaveseen.squarespace.com/display/configuration/PostManagement"
#driver.navigate.to "https://thingsihaveseen.squarespace.com/sharer?src=bm&v=2&u=https%3A%2F%2Fthingsihaveseen.squarespace.com%2Fconfig%23collectionId%3D520d9df3e4b0f0270824e7d4%26module%3Dcontent%26settings-subpanelName%3Dsite-settings&t=Squarespace%20-%20Configuration&cid=520d9df3e4b0f0270824e7d4&mid=520d97f4e4b098edc0ee1039&sel="


# find username field

#wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
#wait.until { driver.find_element(:css => '.dialog-field-email .field-input') }
#element = driver.find_element(:css, '.dialog-field-email .field-input')


# enter username
#element.send_keys squarespace["username"]

# select password field
#wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
#wait.until { driver.find_element(:css => '.dialog-field-password .field-input') }
#element = driver.find_element(:css, '.dialog-field-password .field-input')

# enter password
#element.send_keys squarespace["password"]

# click login button
#wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
#wait.until { driver.find_element(:class => 'saveAndClose') }
#element = driver.find_element(:class, 'saveAndClose')
#element.click


# click "new entry" button
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '#sectionDescription #true') }
element = driver.find_element(:css => '#sectionDescription #true')
element.click


# switch to editor iframe
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '#configuration-container-frame') }
driver.switch_to().frame "configuration-container-frame"

# switch to html mode
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '#mode_html') }
confirmbox = driver.execute_script("document.getElementById('mode_html').click()")

#a = driver.switch_to.alert # switch context to confirmation box
#a.accept # accept switch to html edit mode


# enter blog entry title
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '#titleData') }
element = driver.find_element(:css => '#titleData')
element.clear #click to erase current text content
element.send_keys "test title"


# enter blog entry content
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => 'textarea#body') }
element = driver.find_element(:css => 'textarea#body')
element.click #click to initialize editiable area
element.send_keys "test content"


# switch back to default context
driver.switch_to.default_content

# click save and publish
wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
wait.until { driver.find_element(:css => '#inlineSaveTarget') }
element = driver.find_element(:css => '#inlineSaveTarget')
element.click



