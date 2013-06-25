require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  def test_entry_type
    assert_equal entry_types(:kihon).id, entries(:oi_zuki).entry_type_id
  end

  def test_body_without_fragment_links
    body = entries(:body_with_fragment).body_without_fragment_links
    assert !body.include?("lfrag")
    assert !body.include?("bfrag")
  end

  def test_line_fragments
    assert entries(:bassai).line_fragments.include?(:source => entries(:body_with_fragment), :fragment => "Mr. Ohshima said fumikomi should have a very strong feeling.")
    assert entries(:fumikomi).line_fragments.include?(:source => entries(:body_with_fragment), :fragment => "Mr. Ohshima said fumikomi should have a very strong feeling.")

    assert_equal 2, entries(:oi_zuki).line_fragments.size
    assert entries(:oi_zuki).line_fragments.include?(:source => entries(:body_with_fragment), :fragment => "Mr. Ohshima stressed the importance of making oi-zuki in one movement.")
    assert entries(:oi_zuki).line_fragments.include?(:source => entries(:body_with_fragment), :fragment => "Mr. Ohshima stressed that we should not move our front foot before making the punch.")
  end

  def test_body_fragments
    assert entries(:heian_shodan).body_fragments.include?(:source => entries(:body_with_fragment), :fragment => "=== Heian Shodan * In the first movement, hips go in without hesitation.  They are already open, so just go! * Don't move before you can \"feel\" your opponent. * When \"blocking\" up the middle, feel as if you are attacking your opponent with your elbow.")
  end
end