# frozen_string_literal: true

require 'validify_me/validator/integer_validator'
require 'validify_me/validator/string_validator'

module ValidifyMe
  # Main module for validating the incoming data
  module DataValidator
    def self.included(base)
      base.extend(ClassMethods)
      # base.include(InstanceMethods)
    end

    # This module defines methods that will be called on class-level
    module ClassMethods
      def validator
        @validator ||= Validator.new
      end

      def params(&block)
        validator.instance_eval(&block) if block_given?

        validator.params
      end

      def valid_params?(params)
        validator.params.each do |param|
          next if param.optional? && !params.key?(param.name) && param.data[:constraints].empty?

          handle_param_types(param, params[param.name])
        end
      end

      private

      def handle_param_types(param, param_value)
        case param.data[:type]
        when :integer
          ValidifyMe::Validator::IntegerValidator.new(param, param_value).validate
        when :string
          ValidifyMe::Validator::StringValidator.new(param, param_value).validate
        end
      end
    end

    # This module defines methods that will be called on instance-level
    # module InstanceMethods
    #   def validate(params)
    #     self.class.validator.params.each do |param|
    #       next if param.optional? && !params.key?(param.name) && param.data[:constraints].empty?

    #       handle_param_types(param, params[param.name])
    #     end
    #   end

    #   private

    #   def handle_param_types(param, param_value)
    #     case param.data[:type]
    #     when :integer
    #       ValidifyMe::Validator::IntegerValidator.new(param, param_value).validate
    #     when :string
    #       ValidifyMe::Validator::StringValidator.new(param, param_value).validate
    #     end
    #   end
    # end

    # This class will provide a possibility to manage whether the param should be
    # required or optional
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

    # Helps us determine what is the parameter definition
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
