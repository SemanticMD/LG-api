require 'rspec/expectations'

RSpec::Matchers.define :serialize_to do |expected_serializer, expected_value|
  expected = expected_serializer.new(expected_value).to_json

  match do |actual|
    actual.body === expected
  end
end
