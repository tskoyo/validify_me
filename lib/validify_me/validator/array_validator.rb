# frozen_string_literal: true

require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'
require 'validify_me/errors/wrong_data_type_error'

module ValidifyMe
  module Validator
    # Class responsible for validating array data types
    class ArrayValidator
      attr_reader :param_definition, :param_value

      TYPES = {
        int: Integer,
        str: String,
        hash: Hash,
        arr: Array,
        sym: Symbol
      }.freeze

      def initialize(param_definition, param_value)
        @param_definition = param_definition
        @param_value = param_value
      end

      def validate
        raise Errors::WrongDataTypeError.new(@param_definition.name, @param_value, Array) unless @param_value.is_a?(Array)
        raise Errors::EmptyParameterError, @param_definition.name if @param_value.empty?

        constraints = param_definition.data[:constraints]
        return unless constraints

        validate_each_value_constraint(constraints[:each]) if constraints[:each]
        validate_min_size_constraint(constraints[:min_size]) if constraints[:min_size]
      end

      private

      def validate_each_value_constraint(each_value_constraint)
        each_value_constraint = TYPES[each_value_constraint]
        param_value.each do |value|
          raise Errors::ConstraintParameterError, @param_definition.name unless value.is_a?(each_value_constraint)
        end
      end

      def validate_min_size_constraint(min_size)
        param_value.each do |value|
          raise Errors::ConstraintParameterError, @param_definition.name if value < min_size
        end
      end
    end
  end
end
