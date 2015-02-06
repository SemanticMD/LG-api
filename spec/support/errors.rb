require 'rspec/expectations'

RSpec::Matchers.define :error_not_found do
  match do |actual|
    response.code === '404'
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
