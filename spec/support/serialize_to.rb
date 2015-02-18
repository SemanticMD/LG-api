require 'rspec/expectations'

RSpec::Matchers.define :serialize_to do |expected_serializer, expected_value|
  expected = expected_serializer.new(expected_value).to_json

  match do |actual|
    actual.body === expected
  end

  failure_message_for_should do |response|
    "expected api to return #{expected.inspect} but got #{actual.body.inspect} instead"
  end
end
