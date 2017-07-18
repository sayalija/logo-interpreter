require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get "http://localhost:5600/"
wait = Selenium::WebDriver::Wait.new(:timeout => 15)

codeContainer = wait.until {
  e = driver.find_element(:id, 'step-code')
  e if e.displayed?
}
codeContainer.send_keys "fd 100"

runButton = wait.until {
  e = driver.find_element(:id, 'run-code')
  e if e.displayed?
}
runButton.click

extrasLink = wait.until {
  e = driver.find_element(:id, 'sb-link-extras')
  e if e.displayed?
}
extrasLink.click

downloadLink = wait.until {
  e = driver.find_element(:id, 'screenshot')
  e if e.displayed?
}
downloadLink.click

driver.quit
