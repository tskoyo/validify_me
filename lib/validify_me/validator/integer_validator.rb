# frozen_string_literal: true

require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'

module ValidifyMe
  module Validator
    # Class responsible for validating integer data types
    class IntegerValidator
      attr_reader :param, :value

      COMPARISON_OPERATORS = {
        gt: :>,
        lt: :<,
        gteq: :>=,
        lteq: :<=,
        eq: :==
      }.freeze

      def initialize(param, value)
        @param = param
        @value = value
      end

      def validate
        raise Errors::EmptyParameterError, @param.name if @value.nil?

        @param.data[:constraints].each do |key, constraint_value|
          operator = COMPARISON_OPERATORS[key]

          if operator && @value.public_send(operator, constraint_value)
            raise Errors::ConstraintParameterError, param.name
          end
        end
      end
    end
  end
end
