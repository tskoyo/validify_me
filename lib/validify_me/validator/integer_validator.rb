# frozen_string_literal: true

require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'

module ValidifyMe
  module Validator
    # Class responsible for validating integer data types
    class IntegerValidator
      attr_reader :param, :attr_value

      COMPARISON_OPERATORS = {
        gt: :>,
        lt: :<,
        gteq: :>=,
        lteq: :<=
      }.freeze

      def initialize(param, attr_value)
        @param = param
        @attr_value = attr_value
      end

      def validate
        raise Errors::EmptyParameterError, @param.name if @attr_value.nil?

        @param.data[:constraints].each do |key, value|
          operator = COMPARISON_OPERATORS[key]

          raise Errors::ConstraintParameterError, param.name if operator && @attr_value.public_send(operator, value)
        end
      end
    end
  end
end
