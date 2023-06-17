module ValidifyMe
  module Errors
    class ParameterValidationError < StandardError
      attr_reader :param_name

      def initialize(param_name)
        @param_name = param_name
        super("Parameter '#{param_name}' is required but received an empty value.")
      end
    end
  end
end