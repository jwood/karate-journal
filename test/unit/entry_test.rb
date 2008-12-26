require File.dirname(__FILE__) + '/../test_helper'

class EntryTest < Test::Unit::TestCase
  fixtures :entries, :entry_types

  def test_entry_type
    assert_equal entry_types(:kihon).id, entries(:oi_zuki).entry_type_id
  end
end
