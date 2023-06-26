require 'validify_me/errors/empty_parameter_error'

module ValidifyMe
  module Validator
    class StringValidator
      attr_reader :param, :attr_value

      def initialize(param, attr_value)
        @param = param
        @attr_value = attr_value
      end

      def validate
        raise Errors::EmptyParameterError.new(@param.name) if @attr_value.nil? || @attr_value.empty?
      end
    end
  end
end
