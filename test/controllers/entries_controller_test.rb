require 'test_helper'

class EntriesControllerTest < ActionController::TestCase

  test "should be able to get the complete list of entries" do
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

  test "should be able to fetch the details for a given entry" do
    get :show, id: entries(:oi_zuki)
    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:entry)
    assert assigns(:entry).valid?
    assert_equal "Oi-Zuki", assigns(:entry).title
    assert_equal "Bend that front knee.", assigns(:entry).body
    assert_equal "Master Funakoshi", assigns(:entry).source
    assert_equal 1, assigns(:entry).entry_type_id
  end

  test "should show line fragments from other entries" do
    get :show, id: entries(:bassai)
    assert_response :success
    assert_template 'show'
    assert @response.body.include?("Mr. Ohshima said fumikomi should have a very strong feeling")
  end

  test "should show body fragments from other entries" do
    get :show, id: entries(:heian_shodan)
    assert_response :success
    assert_template 'show'

    assert @response.body.include?("In the first movement, hips go in without hesitation.")
    assert @response.body.include?("When blocking up the middle")
  end

  test "should be able to fetch the form to create a new entry" do
    get :new
    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:entry)
  end

  test "should be able to create a new entry" do
    post :create, entry: { title: "Uraken", body: "Tight fist, loose arm.", source: "Tsutomu Ohshima", entry_type_id: 1 }
    assert_redirected_to entry_path(assigns(:entry))

    entry = Entry.find(assigns(:entry))
    assert_equal "Uraken", entry.title
  end

  test "should be able to fetch the edit form for an existing entry" do
    get :edit, id: entries(:oi_zuki)
    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:entry)
    assert assigns(:entry).valid?
    assert_equal "Oi-Zuki", assigns(:entry).title
    assert_equal "Bend that front knee.", assigns(:entry).body
    assert_equal "Master Funakoshi", assigns(:entry).source
    assert_equal 1, assigns(:entry).entry_type_id
  end

  test "should be able to update an existing entry" do
    entry = entries(:oi_zuki)
    put :update, id: entry, entry: { title: "Oi-Zuki - Lunge Punch", body: "Bent that front knee, and breathe!", source: "Master Funakoshi and Tsutomu Ohshima" }
    assert_redirected_to entry_path(entry)

    entry = Entry.find(entry)
    assert_equal "Oi-Zuki - Lunge Punch", entry.title
    assert_equal "Bent that front knee, and breathe!", entry.body
    assert_equal "Master Funakoshi and Tsutomu Ohshima", entry.source
    assert_equal 1, entry.entry_type_id
  end

  test "should be sent back to the edit screen if the update fails" do
    entry = entries(:oi_zuki)
    put :update, id: entry, entry: { title: "" }
    assert_response :success
    assert_template 'edit'
  end

  test "should be able to destroy an existing entry" do
    assert Entry.find_by_id(entries(:oi_zuki))
    delete :destroy, id: entries(:oi_zuki)
    assert_redirected_to root_path
    assert_nil Entry.find_by_id(entries(:oi_zuki))
  end

  test "should be able to search all entries" do
    get :search, query: "bend knee"
    assert_response :success
    assert_template 'search'

    assert_equal 1, assigns(:results).size
    assert assigns(:results).include?(entries(:oi_zuki))
  end

  test "should successfully handle a search that yields no results" do
    get :search, query: "lkjasdlfj asdlfkj"
    assert_response :success
    assert_template 'search'

    assert_not_nil assigns(:results)
    assert assigns(:results).empty?
  end

  test "should successfully handle searches against large entries" do
    get :search, query: "specific search string"
    assert_response :success
    assert_template 'search'

    assert_equal 1, assigns(:results).size
    assert assigns(:results).include?(entries(:down_block))
  end

  test "should successfully handle searches for a common phrase" do
    get :search, query: "block"
    assert_response :success
    assert_template 'search'

    assert_equal 3, assigns(:results).size
    assert assigns(:results).include?(entries(:down_block))
    assert assigns(:results).include?(entries(:rising_block))
  end

end
