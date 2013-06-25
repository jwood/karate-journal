require 'test_helper'

class EntriesControllerTest < ActionController::TestCase

  def test_index
    get :index
    assert_response :success
    assert_template 'index'

    assert_equal 6, assigns(:kihon_entries).size
    assert assigns(:kihon_entries).include?(entries(:oi_zuki))

    assert_equal 2, assigns(:kata_entries).size
    assert assigns(:kata_entries).include?(entries(:heian_shodan))

    assert_equal 1, assigns(:kumite_entries).size
    assert assigns(:kumite_entries).include?(entries(:ippon_kumite))

    assert_equal 1, assigns(:drill_entries).size
    assert assigns(:drill_entries).include?(entries(:kick_kick))

    assert_equal 1, assigns(:other_entries).size
    assert assigns(:other_entries).include?(entries(:other))

    assert_equal 2, assigns(:senior_visit_entries).size
    assert assigns(:senior_visit_entries).include?(entries(:ohshima_visit))

    assert_equal 1, assigns(:special_training_entries).size
    assert assigns(:special_training_entries).include?(entries(:summer_special_training))

    assert_equal 1, assigns(:experience_entries).size
    assert assigns(:experience_entries).include?(entries(:nisei_week))
  end

  def test_show_entry
    get :show, :id => entries(:oi_zuki).id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:entry)
    assert assigns(:entry).valid?
    assert_equal "Oi-Zuki", assigns(:entry).title
    assert_equal "Bend that front knee.", assigns(:entry).body
    assert_equal "Master Funakoshi", assigns(:entry).source
    assert_equal 1, assigns(:entry).entry_type_id
  end

  def test_get_form_for_new_entry
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:entry)
    assert assigns(:entry).valid?
  end

  def test_get_form_for_existing_entry
    get :show, :id => entries(:oi_zuki).id
    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:entry)
    assert assigns(:entry).valid?
    assert_equal "Oi-Zuki", assigns(:entry).title
    assert_equal "Bend that front knee.", assigns(:entry).body
    assert_equal "Master Funakoshi", assigns(:entry).source
    assert_equal 1, assigns(:entry).entry_type_id
  end

  def test_post_update_for_existing_entry
    entry = entries(:oi_zuki)
    entry.title = "Oi-Zuki - Lunge Punch"
    entry.body = "Bent that front knee, and breathe!"
    entry.source = "Master Funakoshi and Tsutomu Ohshima"

    put :update, { :id => entry.id, :entry => entry.attributes }
    assert_redirected_to entry_path(entry)

    get :show, :id => entries(:oi_zuki).id
    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:entry)
    assert assigns(:entry).valid?
    assert_equal "Oi-Zuki - Lunge Punch", assigns(:entry).title
    assert_equal "Bent that front knee, and breathe!", assigns(:entry).body
    assert_equal "Master Funakoshi and Tsutomu Ohshima", assigns(:entry).source
    assert_equal 1, assigns(:entry).entry_type_id
  end

  def test_destroy
    assert_nothing_raised { Entry.find(entries(:oi_zuki).id) }

    delete :destroy, :id => entries(:oi_zuki).id
    assert_response :redirect
    assert_redirected_to :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) {
      Entry.find(entries(:oi_zuki).id)
    }
  end

  def test_simple_search
    get :search, :query => "bend knee"
    assert_response :success
    assert_template 'search'

    assert_not_nil assigns(:results)
    assert_equal 1, assigns(:results).size
    assert assigns(:results).include?(entries(:oi_zuki))
  end

  def test_empty_search
    get :search, :query => "lkjasdlfj asdlfkj"
    assert_response :success
    assert_template 'search'

    assert_not_nil assigns(:results)
    assert assigns(:results).empty?
  end

  def test_search_with_long_body
    get :search, :query => "specific search string"
    assert_response :success
    assert_template 'search'

    assert_not_nil assigns(:results)
    assert_equal 1, assigns(:results).size
    assert assigns(:results).include?(entries(:down_block))
  end

  def test_search_for_common_term
    get :search, :query => "block"
    assert_response :success
    assert_template 'search'

    assert_not_nil assigns(:results)
    assert_equal 3, assigns(:results).size
    assert assigns(:results).include?(entries(:down_block))
    assert assigns(:results).include?(entries(:rising_block))
  end

  def test_entry_with_line_fragments
    get :show, :id => entries(:bassai).id
    assert_response :success
    assert_template 'show'
  end

  def test_entry_with_body_fragments
    get :show, :id => entries(:heian_shodan).id
    assert_response :success
    assert_template 'show'
  end

end