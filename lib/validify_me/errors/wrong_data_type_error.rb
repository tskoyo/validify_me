# frozen_string_literal: true

module ValidifyMe
  module Errors
    # This error is raised when a parameter is required but it's empty
    class WrongDataTypeError < StandardError
      def initialize(param_name, param_value, expected_type)
        super("Wrong data type for parameter: #{param_name}. Expected #{expected_type}, got: #{param_value.class}")
      end
    end
  end
end
