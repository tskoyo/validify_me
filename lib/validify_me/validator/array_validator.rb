# frozen_string_literal: true

require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'
require 'validify_me/errors/wrong_data_type_error'

module ValidifyMe
  module Validator
    # Class responsible for validating integer data types
    class ArrayValidator
      attr_reader :param_name, :param_value

      def initialize(param_name, param_value)
        @param_name = param_name
        @param_value = param_value
      end

      def validate
        raise Errors::WrongDataTypeError.new(param_name, param_value, Array) unless param_value.is_a?(Array)
      end
    end
  end
end
