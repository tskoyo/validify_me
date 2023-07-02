# frozen_string_literal: true

require 'validify_me/errors/empty_parameter_error'

module ValidifyMe
  module Validator
    # Class responsible for validating string data types
    class StringValidator
      attr_reader :param, :attr_value

      def initialize(param, attr_value)
        @param = param
        @attr_value = attr_value
      end

      def validate
        raise Errors::EmptyParameterError, @param.name if @attr_value.nil? || @attr_value.empty?
      end
    end
  end
end
