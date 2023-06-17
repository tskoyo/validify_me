require 'validify_me/errors/parameter_validation_error'

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
        validate_params!(params)
      end

      private

      def validate_params!(params)
        self.class.validator.params.each do |param|
          next if param.optional? && !params.key?(param.name)
          next if params[param.name]

          raise Errors::ParameterValidationError.new(param.name)
        end
      end
    end

    class Validator
      attr_reader :params

      def initialize
        @params = []
      end

      def validate(params)
        # Logic to validate the params against the defined rules
        # ...
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
      attr_reader :name, :constraints

      def initialize(name, constraints)
        @name = name
        @constraints = constraints
      end

      def value(type, **options)
        constraints[:type] = type
        constraints.merge!(options)
      end

      def required?
        @constraints[:required]
      end

      def optional?
        !required?
      end
    end

    # ---------------- Commented for now ----------------
    # def valid?
    #   errors.empty?
    # end

    # def errors
    #   @errors ||= Errors.new
    # end

    # class Errors
    #   def initialize
    #     @errors = {}
    #   end

    #   def add(attribute, message)
    #     @errors[attribute] ||= []
    #     @errors[attribute] << message
    #   end

    #   def empty?
    #     @errors.empty?
    #   end

    #   def to_hash
    #     @errors
    #   end
    # end
  end
end
