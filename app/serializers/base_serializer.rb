require 'oat/adapters/hal'
class BaseSerializer < Oat::Serializer
  adapter Oat::Adapters::HAL
end
