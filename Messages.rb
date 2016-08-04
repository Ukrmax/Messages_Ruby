#require 'selenium-webdriver'
#require 'watir-webdriver'
require_relative 'Base.rb'
require 'timeout'
#require 'test/unit'
#require 'rubygems'
#$LOAD_PATH << '/Users/maxivanov/Downloads/'
require '/Users/maxivanov/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/appium_lib-8.0.2/lib/appium_lib'

class Messages < Base
  phone_number = ""
  user_id = ""
  test_message_text = "This is a test message"

  star_icon = "//android.widget.ImageView[@content-desc='Favorite']"
  favorites_button = "com.att.android.mobile.attmessages:id/filterbarSavedButton"
  empty_messages_section = "android:id/empty"
  any_avatar = "com.att.android.mobile.attmessages:id/avatar"
  message_text_balloon = "com.att.android.mobile.attmessages:id/balloonText"
  delete_message_from_conversation = "//android.widget.TextView[@test_message_text='Delete Message']"
  delete_All_confirmation_button = "com.att.android.mobile.attmessages:id/primaryButton"
  all_button = "android:id/selectAll"
  menu_button = "//android.widget.ImageButton[@content-desc='Menu']"
  delete_menu_button = "//android.widget.TextView[@test_message_text='Delete']"
  delete_All_button = "com.att.android.mobile.attmessages:id/ListEditClearAllBt"

  messages_app_package_name = "com.att.android.mobile.attmessages"
  messages_app_activity_name = "com.att.ui.screen.ConversationListScreen"

  message_with_code = "//android.widget.TextView[@test_message_text='(746)118-88']"
  conversation_header = "com.att.android.mobile.attmessages:id/ConversationScreenUsername"
  att_sent_code_number = "(746)118-88"
  create_new_message_btn = "com.att.android.mobile.attmessages:id/action_new_message"

  contact_field_in_focus = "com.att.android.mobile.attmessages:id/recipientListField"
  contact_field_out_of_focus = "com.att.android.mobile.attmessages:id/recipientFieldOutOfFocus"

  message_text_locator = "com.att.android.mobile.attmessages:id/ReplyEditText"
  send_message_button = "com.att.android.mobile.attmessages:id/sendButton"

  plus_button_message_text_field = "com.att.android.mobile.attmessages:id/cts_insertButton"
  attach_general_button = "com.att.android.mobile.attmessages:id/cts_attach_general"
  attach_section_from_button = "android:id/up"
  attach_section_image_button = "//android.widget.TextView[@test_message_text='Images']"
  image_folder = "//android.widget.TextView[@test_message_text='Image_formats']"
  jpg_file = "//android.widget.TextView[@test_message_text='jpg.jpg']"
  attach_section_camera_three_dot_menu = "//android.widget.ImageButton[@content-desc='More options']"
  attach_section_camera_list_view = "//android.widget.TextView[@test_message_text='List view']"

  one_image_in_message_text_filed = "Image attachment\n"

  call_button = "com.att.android.mobile.attmessages:id/action_bar_call"

  conversation_buble = "com.att.android.mobile.attmessages:id/conversationBubble"

  message_text_on_initial_page = "com.att.android.mobile.attmessages:id/info"
  mms_message_text_on_initial_page = "1 photo attached"


  def initialize
    @driver = Appium::Driver.new(desired_capabilities).start_driver
  end

  def desired_capabilities
    {
    caps: {
      'platformName' => 'Android',
      'platformVersion' => '4.4',
      'appPackage' => 'com.google.android.googlequicksearchbox',
      'appActivity' => 'com.google.android.launcher.GEL',
      'deviceName' => '03ca33a209478a77',
      'url' => "http://127.0.0.1:4723/wd/hub"
    }
  }
  end

  def setup()
    @driver = Appium::Driver.new(desired_capabilities).start_driver
  end

  def delete_all_messages()
    #  verification if favorites messages is present if yes deleting them
    els = find_elements("xpath", star_icon)
    if els.size != 0
      find_element("id", favorites_button)
      begin
        find_element("id", empty_messages_section)
      rescue
        els1 = find_elements("id", any_avatar)
        els1.each do |x|
            els1[0].click
        end
      end
    end
          begin
            while true
              long_tap_on_message_text_balloon
              tap_on_element("xpath", delete_message_from_conversation)
              tap_on_element("xpath", delete_All_confirmation_button)
            end
          rescue
          end
    # deleting regular Messages
    tap_on_element("id", all_button)
    begin
      find_element("id", empty_messages_section)
    rescue
      tap_on_element("xpath", menu_button)
      tap_on_element("xpath", delete_menu_button)
      tap_on_element("id", delete_All_button)
      tap_on_element("id", delete_All_confirmation_button)
    end
  end

  def long_tap_on_message_text_balloon()
    long_tap("id", message_text_balloon)
  end

  def launch_messages_app()
    launch_app(messages_app_package_name, messages_app_activity_name)
  end

  def retrive_code_from_message()
    tap_on_element("xpath", message_with_code)
    if conversation_has_loaded == true
    else
      sleep(2)
      tap_on_element("xpath", message_with_code)
    end
    m_text = find_element("xpath", message_text_balloon).text
    li = m_text.split(":")
    code=li[-1]
    return code
  end

  def conversation_has_loaded()
    begin
    element = find_element("xpath", conversation_header).text
    assert_text_equality(element, att_sent_code_number)
    return true
  rescue
    return false
    end
  end

  def create_and_send_new_message()
      create_new_message
  end

  def create_new_message()
    tap_on_element("id", create_new_message_btn)
  end

  def type_phone_number
    begin
      find_element("id", contact_field_in_focus)
    rescue
      tap_on_element("id", contact_field_out_of_focus)
      keycodes = {0 => 7, 1 => 8, 2 => 9, 3 => 10, 4 => 11,
        5 => 12, 6 => 13, 7 => 14, 8 => 15, 9 => 16}
      li = phone_number.split("")
      code_list = []
      i = 0
      while i < li.size
        code_list.push(keycodes[Integer(li[i])])
        i += 1
      end
        i = 0
        while i < code_list.size
          send_key_code(code_list[i])
          i += 1
        end
    end
  end

  def fill_message_text_field()
    fill_out_filed("id", message_text_locator, test_message_text)
    assert_text_equality("id", message_text_locator, test_message_text)
  end

  def send_jpg_image()
    create_new_message
    type_phone_number(phone_number)
  end

  def attach_jpg_immage_to_message()
    tap_plus_button_text_message_field
    tap_on_element("id", attach_general_button)
    tap_on_element("id", attach_section_from_button)
    tap_on_element("xpath", attach_section_image_button)
    tap_on_element("xpath", image_folder)
    begin
      tap_on_element("xpath", jpg_file)
    rescue
      tap_on_element("xpath", attach_section_camera_three_dot_menu)
      tap_on_element("xpath", attach_section_camera_list_view)
      tap_on_element("xpath", jpg_file)
    end
    tap_on_send_message_button
  end

  def tap_plus_button_text_message_field()
    tap_on_element("id", plus_button_message_text_field)
  end

  def tap_on_send_message_button()
    tap_on_element("id", send_message_button)
  end

  def verify_message_was_sent()
    el = find_element("id", message_text_balloon).text
    assert_text_equality(el, one_image_in_message_text_filed)
  end

  def verify_message_with_image_was_sent()
    el = find_element("id", message_text_balloon).text
    assert_text_equality(el, one_image_in_message_text_filed)
  end

  def make_a_call_from_the_sent_message()
    tap_on_element("id", call_button)
  end

  def verify_that_message_was_sent_and_received_to_the_same_number()
      bubbles = find_elements("id", conversation_buble)
      raise "No message in conversation found" unless bubbles.size == 2
      el = find_element("id", message_text_balloon).text
      assert_text_equality(el, test_message_text)
  end

  def verify_image_was_sent_and_received_to_the_same_number()
    bubbles = find_elements("id", conversation_buble)
    raise "No message in conversation found" unless bubbles.size == 2
    el = find_element("id", conversation_buble).attribute("name")
    assert_text_equality(el, one_image_in_message_text_filed)
  end

  def verify_message_is_not_present()
    els = find_elements("id", mms_message_text_on_initial_page)
    raise "The message is still present" unless els == test_message_text
  end

  def verify_mms_message_is_not_present()
    el = find_element("id", mms_message_text_on_initial_page).text
    raise "The message is still present" unless el == test_message_text
  end

  def verify_conversation_is_deleted()
    begin
      verify_message_is_not_present
    rescue
      sleep(10)
      verify_message_is_not_present
    end
  end

  def verify_mms_messages_was_deleted()
    begin
      verify_mms_message_is_not_present
    rescue
      sleep(10)
      verify_mms_message_is_not_present
    end
  end

  def verify_message_is_in_favorites()
    tap_on_element("id", favorites_button)
    el = find_element("id", message_text_on_initial_page).text
    assert_text_equality(el, test_message_text)
    is_element_present("xpath", star_icon)
  end

  def teardown()
    @driver.quit
  end

end
