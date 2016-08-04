require 'test/unit'
require_relative 'Messages.rb'

class Smoke  < Test::Unit::TestCase

  def test_t
    m_page = Messages.new
    m_page.start_activity_inheritance
    m_page.teardown
  end

  def test_tt
    m_page = Messages.new
    m_page.delete_all_messages
    m_page.teardown
  end


end
