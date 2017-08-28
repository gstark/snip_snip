require 'test_helper'

module SnipSnip
  class ReporterTest < ActiveSupport::TestCase
    FakeResult = Struct.new(:class_name, :primary_key, :unused, :stack)

    test '#initialize' do
      first_user, second_user = [User.first, User.second]
      [first_user.id, first_user.created_at, first_user.updated_at]
      [second_user.first_name, second_user.last_name]

      results = Reporter.new.results

      assert_equal 2, results.length
      assert_equal %w[first_name last_name], results.first.unused.sort
      assert_equal %w[created_at id updated_at], results.second.unused.sort
    end

    test '#report none' do
      assert_logged([]) { Reporter.new.report(nil) }
    end

    test '#report some' do
      reporter = Reporter.new
      reporter.results = [FakeResult.new('1', 'a', ['unused1'], ['stack1']), FakeResult.new('2', 'a', ['unused2'], ['stack2'])]

      expected = ["c#a", "  1 a: unused1", "  2 a: unused2"]
      assert_logged(expected) { reporter.report("c#a") }
    end
  end
end
