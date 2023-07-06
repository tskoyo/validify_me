# frozen_string_literal: true

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
    before(:all) do
      Person.params do
        optional(:name).value(:string)
        required(:age).value(:integer, gt: 0, lt: 100)
        required(:level).value(:integer, eq: 5)
      end
    end

    let(:person) { Person.new }

    it 'returns the defined parameters' do
      expect(Person.params).to include(
        an_instance_of(ValidifyMe::DataValidator::ParameterDefinition),
        an_instance_of(ValidifyMe::DataValidator::ParameterDefinition)
      )
    end

    context 'when an empty parameter is passed' do
      it 'should raise ParameterValidationError' do
        expect { person.validate(name: 'John') }.to raise_error(ValidifyMe::Errors::EmptyParameterError)
      end
    end

    context 'when wrong value for parameter is passed' do
      it 'should raise ConstraintParameterError' do
        expect { person.validate(age: -2) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
        expect { person.validate(age: 101) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
        expect { person.validate(age: 18, level: 6) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
      end
    end
  end
end
