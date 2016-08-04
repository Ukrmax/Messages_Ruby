require "selenium-webdriver"

class Browser

  def initialize
    @driver = Selenium::WebDriver.for :firefox
  end

  def setup
    @driver = Selenium::WebDriver.for :firefox
  end

  def teardown()
    @driver.quit
  end


end
