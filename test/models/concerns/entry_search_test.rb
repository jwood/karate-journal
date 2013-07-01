require 'test_helper'

class EntrySearchTest < ActiveSupport::TestCase

  test "should be able to search all entries" do
    results = Entry.search(%w{bend knee})
    assert_equal 1, results.size
    assert results.include?(entries(:oi_zuki))
  end

  test "should successfully handle a search that yields no results" do
    results = Entry.search(%w{lkjasdlfj asdlfkj})
    assert results.empty?
  end

  test "should successfully handle searches against large entries" do
    results = Entry.search(%w{specific search string})
    assert_equal 1, results.size
    assert results.include?(entries(:down_block))
  end

  test "should successfully handle searches for a common phrase" do
    results = Entry.search(%w{block})
    assert_equal 3, results.size
    assert results.include?(entries(:down_block))
    assert results.include?(entries(:rising_block))
  end

end
