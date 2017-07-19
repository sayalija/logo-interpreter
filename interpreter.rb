require 'selenium-webdriver'


prefs = {
    default_directory: "./"+ ARGV[1]
}

options = Selenium::WebDriver::Chrome::Options.new
options.add_preference(:download, prefs)
options.add_argument("--kiosk");
driver = Selenium::WebDriver.for :chrome,  options: options

wait = Selenium::WebDriver::Wait.new(:timeout => 15)

driver.get "http://localhost:4000"

def get_image_and_screenshot(wait,driver,code,file_name)
  begin
    code_container = wait.until {
      e = driver.find_element(:id, 'step-code')
      e if e.displayed?
    }
    code_container.send_keys code.split("\t").join("").split("\n").join("")

    run_button = wait.until {
      e = driver.find_element(:id, 'run-code')
      e if e.displayed?
    }
    run_button.click

    sleep 3

    driver.save_screenshot("./#{ARGV[1]}/ #{file_name}_screenshot.png")

    extras_link = wait.until {
      e = driver.find_element(:id, 'sb-link-extras')
      e if e.displayed?
    }
    extras_link.click

    download_link = wait.until {
      e = driver.find_element(:id, 'screenshot')
      e if e.displayed?
    }
    download_link.click
    download_link.submit

  rescue
    p "Sometimes it's okey to fail, don't worry. :) "
  end

end


def interprete(wait, driver)
  File.read(ARGV.first).split("\n").each { |each_file|
    file_name = each_file.split(".").first
    get_image_and_screenshot(wait, driver, File.read(each_file), file_name)
    File.rename("./#{ARGV[1]}/logo_drawing.png", "./#{ARGV[1]}/#{file_name}_drawing.png")
  }
end

interprete(wait, driver)

driver.quit