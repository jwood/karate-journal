require File.dirname(__FILE__) + '/../test_helper'

class EntryTypeTest < ActiveSupport::TestCase
  fixtures :all

  def test_description
    assert_equal 'Kihon', entry_types(:kihon).description
  end
  
end
