# Keep Our Parks Clean!

# Submitted By:
# kbennoune

# Difficulty:
# Medium

# Tags:
# metaprogramming

# Instructions:
# Can you change a method name in a class without littering your class with unused methods?

# Hidden Code:
# There is hidden code with assertions that is also being run to test out your code.

gem "minitest"

require 'minitest/autorun'
require 'minitest/pride'

class BasePark
  def self.clean_alias_method(new_name,old_name)
    alias_method(new_name, old_name)
    remove_method(old_name)
  end
end

class Park < BasePark
  def bad_method_name
    "This should have a better name"
  end

  clean_alias_method(:good_method_name,:bad_method_name)
end

class ParkTest < MiniTest::Test
  def test_should_have_better_name
    assert_equal(Park.new.good_method_name, "This should have a better name")
  end

  def test_bad_method_removed
    assert_equal(Park.new.respond_to?(:bad_method_name),false)
  end
end