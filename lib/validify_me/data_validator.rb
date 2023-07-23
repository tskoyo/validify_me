# frozen_string_literal: true

require 'validify_me/validator/integer_validator'
require 'validify_me/validator/string_validator'
require 'pry'

module ValidifyMe
  # Main module for validating the incoming data
  module DataValidator
    def self.included(base)
      base.extend(ClassMethods)
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

          validator_class_name = "ValidifyMe::Validator::#{param.data[:type].to_s.capitalize}Validator"

          Object.const_get(validator_class_name).new(param, params[param.name]).validate
        end
      end
    end

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
        @data[:type] = type
        @data.merge!(constraints: options)

        self
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
