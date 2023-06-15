require 'validify_me/data_validator'
require 'pry'

RSpec.describe ValidifyMe::DataValidator do
  class DummyClass
    include ValidifyMe::DataValidator
  end

  describe '.params' do
    let(:params) do
      DummyClass.params do
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
  end
end
