require 'test_helper'

class EntryTypeTest < ActiveSupport::TestCase

  def test_description
    assert_equal 'Kihon', entry_types(:kihon).description
  end

end
