
gem 'minitest'

require 'minitest/autorun'
require 'minitest/pride'


class PhoneNumberTest < MiniTest::Test

  def phone_number?(num)
    digits = num.gsub(/[\-\(\)\s]/,"")
    puts digits
    return false unless digits =~ /\A\d+\z/
    return false unless (digits.size == 10 || digits.size == 7)
    true
  end

  def test_5555555555
    assert_equal phone_number?("5555555555"), true
  end

  def test_555555555
    assert_equal phone_number?("555555555"), false # missing a digit
  end

  def test_555dash5555
    assert_equal phone_number?("555-5555"), true
  end

  def test_areacode
    assert_equal phone_number?("(555) 555-5555"), true
  end

  def test_areacodemissingdigit
    assert_equal phone_number?("(555) 555-555"), false
  end

  def test_areacode2
    assert_equal phone_number?("555-555-5555"), true
  end

  def test_areacode2_extraletter
    assert_equal phone_number?("555a-555-5555"), false # extraneous digit
  end

  def test_asterisk
    assert_equal phone_number?("555*555-5555"), false # extraneous digit
  end

  def test_areacode2_replaceletter
    assert_equal phone_number?("55a-555-5555"), false # extraneous digit
  end
end