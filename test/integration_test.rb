require 'test_helper'

class IntegrationTest < ActionDispatch::IntegrationTest
  test 'GET /action1' do
    assert_logged([]) { get action1_path }
  end

  test 'GET /action2' do
    expected = [
      'users#action2',
      %(  {:class=>"User", :key=>1, :unused=>["id", "first_name", "last_name", "created_at", "updated_at"], :used=>[]}),
      %(    app/controllers/users_controller.rb:10:in `action2'),
      %(  {:class=>"User", :key=>2, :unused=>["id", "first_name", "last_name", "created_at", "updated_at"], :used=>[]}),
      %(    app/controllers/users_controller.rb:10:in `action2')
    ]
    assert_logged(expected) { get action2_path }
  end
end
