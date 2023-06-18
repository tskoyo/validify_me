require 'validify_me/data_validator'
require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'

require 'byebug'

RSpec.describe ValidifyMe::DataValidator do
  class Person
    include ValidifyMe::DataValidator

    attr_reader :params
  end

  describe '.params' do
    let(:params) do
      Person.params do
        optional(:name).value(:string)
        required(:age).value(:integer, gt: 0, lt: 100)
      end
    end

    it 'returns the defined parameters' do
      expect(params).to include(
        an_instance_of(ValidifyMe::DataValidator::ParameterDefinition),
        an_instance_of(ValidifyMe::DataValidator::ParameterDefinition)
      )
    end

    context 'when an empty parameter is passed' do
      it 'should raise ParameterValidationError' do
        person = Person.new

        expect { person.validate(name: 'John') }.to raise_error(ValidifyMe::Errors::EmptyParameterError)
      end
    end

    context 'when wrong value for parameter is passed' do
      person = Person.new
      
      it 'should raise ConstraintParameterError' do
        expect { person.validate(age: 101) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
      end
    end
  end
end
