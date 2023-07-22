require 'validify_me/validator/array_validator'
require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'
require 'validify_me/errors/wrong_data_type_error'

require 'pry'


RSpec.describe ValidifyMe::Validator::ArrayValidator do
  subject { described_class.new(param_name, param_value) }

  let(:required) { true }
  let(:param_name) { :codes }

  let(:parameter) do
    ValidifyMe::DataValidator::ParameterDefinition.new(param_name, required: required).value(:array)
  end

  context 'when non-array type is provided' do
    let(:param_value) { 'Hello world' }

    it 'should raise WrongDataTypeError' do
      expect { subject.validate }.to raise_error(ValidifyMe::Errors::WrongDataTypeError)
     end
  end

  context 'empty param value' do
    let(:param_value) { [] }

    it 'should raise EmptyParameterError' do
      expect { subject.validate }.to raise_error(ValidifyMe::Errors::EmptyParameterError)
    end
  end

  context 'correct data type is provided' do
    let(:param_value) { [2512, 2561, 2109, 4921, 9512 ]}

    it 'shouldn\'t raise any error' do
      expect { subject.validate }.not_to raise_error
    end
  end
end
