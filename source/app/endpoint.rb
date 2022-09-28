# frozen_string_literal: true

class Endpoint
  attr_reader :route

  delegate :path, :content, :http_method, to: :route

  def self.build(*args)
    new(*args).build
  end

  def initialize(route)
    @route = route
  end

  def build
    content = self.content
    Sinatra::Delegator.target.public_send(http_method, path) do
      content
    end
  end
end
