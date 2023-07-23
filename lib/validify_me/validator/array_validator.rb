# frozen_string_literal: true

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
        validate_size_constraints(constraints[:min_size], constraints[:max_size])
      end

      private

      def validate_each_value_constraint(each_value_constraint)
        each_value_constraint = TYPES[each_value_constraint]

        invalid_values = []
        @param_value.each_slice(1000) do |slice|
          invalid_values.concat(slice.reject { |value| value.is_a?(each_value_constraint) })
        end

        raise Errors::ConstraintParameterError, @param_definition.name if invalid_values.any?
      end

      def validate_size_constraints(min_size, max_size)
        errors = []

        if min_size
          invalid_values = []
          @param_value.each_slice(1000) do |slice|
            invalid_values.concat(slice.reject { |value| value >= min_size })
          end
          errors.concat(invalid_values.map { @param_definition.name }) if invalid_values.any?
        end

        if max_size
          invalid_values = []
          @param_value.each_slice(1000) do |slice|
            invalid_values.concat(slice.reject { |value| value <= max_size })
          end
          errors.concat(invalid_values.map { @param_definition.name }) if invalid_values.any?
        end

        raise Errors::ConstraintParameterError, errors.join(', ') if errors.any?
      end
    end
  end
end
