module ValidifyMe
  module DataValidator
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def params(&block)
        context = Context.new

        return {} unless block_given?

        context.instance_eval(&block)
      end
    end

    class Context
      attr_reader :params

      def initialize
        @params = []
      end

      def optional(name)
        parameter = ParameterDefinition.new(name, {})
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
