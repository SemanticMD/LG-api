require 'rspec/expectations'

RSpec::Matchers.define :error_not_found do
  match do |actual|
    response.code === '404'
  end
end

RSpec::Matchers.define :error_deny_access do
  match do |actual|
    response.code === '401'
  end
end

RSpec::Matchers.define :error_not_found_with do |expected_message|
  match do |actual|
    response.code === '404'
    response.body  === {
      code: '404',
      error: 'not_found',
      message: expected_message
    }.to_json
  end
end

RSpec::Matchers.define :error_deny_access_with do |expected_message|
  match do |actual|
    response.code === '401'
    response.body  === {
      code: '401',
      error: 'unauthenticated',
      message: expected_message
    }.to_json
  end
end

RSpec::Matchers.define :error_invalid_resource_with do |expected_errors|
  match do |actual|
    response.code === '422'
    response.body  === {
      code: '422',
      errors: expected_errors
    }.to_json
  end

  failure_message_for_should do |response|
    normalised_response = {
      code: '422',
      errors: expected_errors
    }.to_json
    decoded = response.body

    "expected api to have exposed 422, #{normalised_response.inspect}, got #{response.code} #{decoded.inspect} instead."
  end
end
