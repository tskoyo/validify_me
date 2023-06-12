module ValidifyMe
  module DataValidator
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def validates_presence_of(*attributes)
        attributes.each do |attribute|
          define_method("#{attribute}_presence_validation") do
            value = send(attribute)
            if value.empty?
              errors.add(attribute, 'must be present')
            end
          end

          validate "#{attribute}_presence_validation"
        end
      end
    end

    def valid?
      errors.empty?
    end

    def errors
      @errors ||= Errors.new
    end

    class Errors
      def initialize
        @errors = {}
      end

      def add(attribute, message)
        @errors[attribute] ||= []
        @errors[attribute] << message
      end

      def empty?
        @errors.empty?
      end

      def to_hash
        @errors
      end
    end
  end
end
