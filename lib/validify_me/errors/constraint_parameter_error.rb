module ValidifyMe
  module Errors
    module ConstraintParameterError
      attr_reader :param_name

      def initialize(param_name)
        @param_name = param_name
        super("Parameter '#{param_name}' does not meet specified constraints.")
      end
    end
  end
end