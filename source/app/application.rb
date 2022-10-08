# frozen_string_literal: true

# Application contains the application definition
#
# This loads config file into memory and creates the routes
class Application
  class << self
    def config_file_path(path = @config_file_path)
      @config_file_path = path
    end

    def instance
      @instance ||= new
    end

    def reset
      @instance = nil
    end

    delegate :start, :endpoints, :append, to: :instance
  end

  def start
    routes.each(&:apply)
  end

  def endpoints
    @endpoints ||= {}
  end

  def append(route)
    endpoints[route.normalized_endpoint]&.update(route) ||
    endpoints[route.normalized_endpoint] = Endpoint.build(route)
  end

  private

  delegate :config_file_path, to: :class
  delegate :routes, to: :config

  def config
    @config ||= Config.load_file(config_file_path)
  end
end
