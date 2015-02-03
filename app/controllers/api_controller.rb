class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # Add _attributes to keys for nested json objects coming from client.
  def rename_nested_attributes(attrs, keys)
    keys.each do |key|
      attrs[:"#{key}_attributes"] = attrs.delete(key) if attrs.has_key?(key)
    end

    attrs
  end
end
