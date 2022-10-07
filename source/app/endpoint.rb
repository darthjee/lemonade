# frozen_string_literal: true

# Class responsible for building endpoints from +Route+ configs
#
# The routes are then sent to Sinatra for building
class Endpoint
  attr_accessor :route

  delegate :path, :content, :http_method, to: :route

  def self.build(route)
    endpoint = endpoint_for(route)
    if endpoint.route == route
      endpoint.build
    else
      endpoint.route.disable!
      endpoint.route = route
    end
  end

  def self.endpoint_for(route)
    Application.endpoints[route.normalized_endpoint] ||= new(route)
  end

  def initialize(route)
    @route = route
  end

  def build
    endpoint = self
    Sinatra::Delegator.target.public_send(http_method, path) do
      endpoint.content
    end
  end
end
