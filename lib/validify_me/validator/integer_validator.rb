require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'

module ValidifyMe
  module Validator
    class IntegerValidator
      attr_reader :param, :attr_value

      def initialize(param, attr_value)
        @param = param
        @attr_value = attr_value
      end

      def validate
        raise Errors::EmptyParameterError.new(@param.name) if @attr_value.nil?

        @param.data[:constraints].each do |key, value|
          case key
          when :gt
            raise Errors::ConstraintParameterError.new(param.name) if @attr_value < value
          when :lt
            raise Errors::ConstraintParameterError.new(param.name) if @attr_value > value
          end          
        end
      end
    end
  end
end
