# frozen_string_literal: true

class BCDD::Result
  class Contract::ForTypesAndValues
    include Contract::Interface

    def initialize(types_and_values)
      @types_and_values = types_and_values.transform_keys(&:to_sym)

      @types_contract = Contract::ForTypes.new(@types_and_values.keys)
    end

    def allowed_types
      @types_contract.allowed_types
    end

    def type?(type)
      @types_contract.type?(type)
    end

    def type!(type)
      @types_contract.type!(type)
    end

    def type_and_value!(data)
      type, value = data.type, data.value

      value_checking = @types_and_values[type!(type)]

      checking_result = value_checking === value

      return value if checking_result || (Contract.nil_as_valid_value_checking? && checking_result.nil?)

      raise Contract::Error::UnexpectedValue.build(type: type, value: value)
    rescue ::NoMatchingPatternError => e
      raise Contract::Error::UnexpectedValue.build(type: data.type, value: data.value, cause: e)
    end
  end
end
