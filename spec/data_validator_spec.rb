# frozen_string_literal: true

require 'validify_me/data_validator'
require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'

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
    
    let(:valid_params)  { { name: 'John', age: 25 } }

    context 'invalid params passed' do
      it 'raises an error for negative age' do
        expect { subject.valid_params?(age: -2) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
      end
  
      it 'raises an error for the value larger than 100' do
        expect { subject.valid_params?(age: 101) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
      end
  
      it 'raises an error for the value 100' do
        expect { subject.valid_params?(age: 100) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
      end
  
      it 'raises an error for the value 0' do
        expect { subject.valid_params?(age: 0) }.to raise_error(ValidifyMe::Errors::ConstraintParameterError)
      end

      it 'raises an error for an empty age parameter' do
        expect { subject.valid_params?(name: 'John') }.to raise_error(ValidifyMe::Errors::EmptyParameterError)
      end
    end

    context 'valid params passed' do
      context 'valid age without name passed' do
        it 'validates params correctly' do
          expect { subject.valid_params?(age: 29) }.not_to raise_error
        end
      end

      context 'both name and age passed' do
        it 'validates params correctly' do
          expect { subject.valid_params?(valid_params) }.not_to raise_error
        end
      end
    end
  end
end
