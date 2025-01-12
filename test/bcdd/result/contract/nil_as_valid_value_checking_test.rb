# frozen_string_literal: true

require 'test_helper'

class BCDD::Result
  class Contract::NiltAsValidValueCheckingTest < Minitest::Test
    test 'BCDD::Result::Expectations' do
      _Result = BCDD::Result::Expectations.new(
        success: {
          ok: ->(value) {
            case value
            in Numeric then nil
            end
          }
        }
      )

      assert_raises(Contract::Error::UnexpectedValue) do
        _Result::Success(:ok, 1)
      end

      Contract.nil_as_valid_value_checking!

      result = _Result::Success(:ok, 1)

      assert result.success?(:ok)
      assert_equal(1, result.value)
    ensure
      Contract.nil_as_valid_value_checking!(enabled: false)
    end

    test 'BCDD::Result::Context::Expectations' do
      _Result = BCDD::Result::Context::Expectations.new(
        success: {
          ok: ->(value) {
            case value
            in { number: Numeric } then nil
            end
          }
        }
      )

      assert_raises(Contract::Error::UnexpectedValue) do
        _Result::Success(:ok, number: 1)
      end

      Contract.nil_as_valid_value_checking!

      result = _Result::Success(:ok, number: 1)

      assert result.success?(:ok)
      assert_equal({ number: 1 }, result.value)
    ensure
      Contract.nil_as_valid_value_checking!(enabled: false)
    end
  end
end
