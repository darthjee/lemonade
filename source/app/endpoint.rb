# frozen_string_literal: true

# Class responsible for building endpoints from +Route+ configs
#
# The routes are then sent to Sinatra for building
class Endpoint
  attr_accessor :route

  delegate :path, :content, :http_method, to: :route

  def self.build(route)
    new(route).tap(&:build)
  end

  def initialize(route)
    @route = route
  end

  def update(route)
    self.route.disable!
    @route = route
  end

  def build
    endpoint = self
    Sinatra::Delegator.target.public_send(http_method, path) do
      endpoint.content
    end
  end
end
