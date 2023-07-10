# frozen_string_literal: true

require 'validify_me/data_validator'
require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'

require 'byebug'

RSpec.describe ValidifyMe::DataValidator do
  subject do
    Class.new do
      include ValidifyMe::DataValidator
    end
  end

  describe '.params' do
    before do
      subject.params do
        optional(:name).value(:string)
        required(:age).value(:integer, gt: 0, lt: 100)
      end
    end

    it 'returns the defined parameters' do
      expect(subject.params).to include(
        an_instance_of(ValidifyMe::DataValidator::ParameterDefinition),
        an_instance_of(ValidifyMe::DataValidator::ParameterDefinition)
      )
    end

    context 'when an empty age parameter is passed' do
      it 'should raise ParameterValidationError' do
        expect { subject.valid_params?(name: 'John') }.to raise_error(ValidifyMe::Errors::EmptyParameterError)
      end

      context 'when both required and required params are filled correctly' do
        it 'shouldn\'t raise an error' do
          expect { subject.valid_params?(name: 'John', age: 25) }.not_to raise_error
        end
      end
    end

    context 'when wrong value for parameter is passed' do
      it 'should raise ConstraintParameterError' do
        expect { subject.valid_params?(age: -2) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
        expect { subject.valid_params?(age: 101) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
      end
    end
  end
end
