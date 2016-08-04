


class Base

  def find_element(locatorMode, locator)
      element = nul
      if locatorMode == "id"
        element = driver.find_element(:id, locator)
      elsif
        locatorMode == "xpath"
        element = driver.find_element(:xpath, locator)
      elsif locatorMode == "css"
          element = driver.find_element(:css, locator)
      else element == "name"
          element = driver.find_element(:name, locator)
      end
  end


  def find_elements(locatorMode, locator)
      elements = nul
      if locatorMode == "id"
        elements = driver.find_element(:id, locator)
      elsif
        locatorMode == "xpath"
        elements = driver.find_element(:xpath, locator)
      elsif locatorMode == "css"
          elements = driver.find_element(:css, locator)
      else element == "name"
          elements = driver.find_element(:name, locator)
      end
  end

  def long_tap(locatorMode, locator)
    el = find_element(locatorMode, locator)
    Appium::TouchAction.new.press(element: el).wait(1000).release.perform
  end

  def launch_app(packageName, activityName)
    @driver.start_activity app_package: packageName, app_activity: activityName
  end

  def tap_on_element(locatorMode, locator)
    begin
      find_element(locatorMode, locator).click()
    rescue
      sleep(2)
      find_element(locatorMode, locator).click()
    end
  end

  def fill_out_filed(locatorMode, locator, text)
    find_element(locatorMode, locator).clear()
    find_element(locatorMode, locator).send_keys(text)
  end

  def is_element_present(locatorMode, locator)
    @driver.manage.timeouts.implicit_wait = 10
    begin
      find_element(locatorMode, locator)
    rescue NoSuchElementException
      puts'Caught NoSuchElementException'
    end
  end

  def assert_text_equality(locatorMode, locator, text)
    el = find_element(locatorMode, locator)
    begin
      el == text
    rescue
      puts "Assert Failed"
    end

    def send_key_code(key_number)
      driver.press_keycode(key_number)
    end




end



# chromedriver_path = File.join(File.absolute_path('/Users/maxivanov/Documents/Projects/Gecko_driver/geckodriver', File.dirname(__FILE__)),"browsers","geckodriver")
# Selenium::WebDriver::Chrome.driver_path = chromedriver_path
