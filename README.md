# "ValidifyMe"

ValidifyMe is a Ruby library that combines validation and serialization functionality, providing a comprehensive solution for managing and processing data in your Ruby applications. It simplifies the task of validating and serializing data by offering a unified and intuitive interface.

## Features

- <b>Validation</b>: Perform data validation using customizable rules and constraints. Ensure data integrity and enforce validation rules with ease. <br>
- <b>Serialization</b>: Serialize data into various formats, such as JSON, XML, or YAML. 
Convert Ruby objects into a structured representation for storage or communication purposes.
- <b>Flexible Configuration</b>: Customize validation rules and serialization options to suit your specific requirements.
- <b>Easy Integration</b>: Seamlessly integrate ValidifyMe into your existing Ruby projects with minimal code changes.
- <b>Extensible and Composable</b>: Take advantage of the modular architecture to add your own custom validators and serializers.

## Installation

Add the following line to your Gemfile:

`gem 'validify_me'`

Then, run the following command to install the gem:

`bundle install`

## Usage

Here's a simple example demonstrating how to use ValidifyMe for data validation and serialization:

<b><i><span>Note: This library is still in progress so some data might not be accurate!</span></i></b>

```
require 'validify_me'

class User
  include ValidifyMe::Serializer

  attr_accessor :name, :age

  serialize_as :json
end

class ShowUser
  include ValidifyMe::DataValidator

  params do
    required(:name).value(:string)
    required(:age).value(:integer, gt: 0, lt: 100)
  end

  def call
    return { errors: error_messages, status: 422 }.to_json unless valid_params?

    users = rom.relations[:users]
      .select(:name, :age)
      .to_a

    { result: users }
  end
end
```
