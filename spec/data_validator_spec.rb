require 'validify_me/data_validator'
require 'validify_me/errors/parameter_validation_error'
require 'pry'

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

    context 'we pass an empty parameter' do
      it 'should raise ParameterValidationError' do
        person = Person.new

        expect { person.validate(name: 'John') }.to raise_error(ValidifyMe::Errors::ParameterValidationError)
      end
    end
  end
end
