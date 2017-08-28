require 'test_helper'

module SnipSnip
  class RegistryTest < ActiveSupport::TestCase
    test '#clear' do
      registry = Registry.new
      registry.entries = [ {model: :a }, {model: :b}, {model: :c}]

      registry.clear

      assert_empty registry.entries
    end

    test '#each_entry no block' do
      expected = [:a, :b, :c]
      registry = Registry.new
      registry.entries = expected

      actual = []
      registry.each_entry { |entry| actual << entry }

      assert_equal expected, actual
    end

    test '#each_entry block' do
      registry = Registry.new

      assert_kind_of Enumerator, registry.each_entry
    end

    test '#register' do
      registry = Registry.new

      registry.register(:a, [])

      assert_equal [{ model: :a, stack: [] }], registry.entries
    end

    test '::instance' do
      assert_kind_of Registry, Registry.instance
    end
  end
end
