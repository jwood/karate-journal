require File.dirname(__FILE__) + '/../test_helper'

class EntryTypeTest < Test::Unit::TestCase
  fixtures :entry_types

  def test_description
    assert_equal 'Kihon', entry_types(:kihon).description
  end
  
end
