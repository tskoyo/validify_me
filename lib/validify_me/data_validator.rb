require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'

module ValidifyMe
  module DataValidator
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end

    module ClassMethods
      def validator
        @validator ||= Validator.new
      end

      def params(&block)
        validator.instance_eval(&block) if block_given?

        validator.params
      end
    end

    module InstanceMethods
      def validate(params)
        self.class.validator.params.each do |param|
          next if param.optional? && !params.key?(param.name) && param.data[:constraints].empty?

          handle_constraints(param, params[param.name])

          raise Errors::EmptyParameterError.new(param.name)
        end
      end

      private

      def handle_constraints(param, incoming_value)
        param.data[:constraints].each do |key, value|
          case key
          when :gt
            raise Errors::ConstraintParameterError.new(param.name) if incoming_value < value
          when :lt
            raise Errors::ConstraintParameterError.new(param.name) if incoming_value > value
          end
        end
      end
    end

    class Validator
      attr_reader :params

      def initialize
        @params = []
      end

      def required(name)
        parameter = ParameterDefinition.new(name, required: true)
        @params << parameter
        parameter
      end

      def optional(name)
        parameter = ParameterDefinition.new(name, required: false)
        @params << parameter
        parameter
      end
    end

    class ParameterDefinition
      attr_reader :name, :data

      def initialize(name, data)
        @name = name
        @data = data
      end

      def value(type, **options)
        data[:type] = type
        data.merge!(constraints: options)
      end

      def required?
        @data[:required]
      end

      def optional?
        !required?
      end
    end
  end
end
