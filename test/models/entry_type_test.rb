require 'test_helper'

class EntryTypeTest < ActiveSupport::TestCase

  test "should be able to easily find the entry type by its description" do
    assert_equal EntryType.KIHON, entry_types(:kihon)
  end

end
