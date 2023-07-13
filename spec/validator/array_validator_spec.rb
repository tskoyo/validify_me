require 'validify_me/validator/array_validator'
require 'validify_me/errors/empty_parameter_error'
require 'validify_me/errors/constraint_parameter_error'
require 'validify_me/errors/wrong_data_type_error'

require 'pry'


RSpec.describe ValidifyMe::Validator::ArrayValidator do
  context 'when non-array type is provided' do
    let(:param_name) { :codes }
    let(:param_value) { 'Hello world' }

    subject { described_class.new(param_name, param_value) }

    it 'should raise WrongDataTypeError' do
      expect { subject.validate }.to raise_error(ValidifyMe::Errors::WrongDataTypeError)
     end
  end
end
