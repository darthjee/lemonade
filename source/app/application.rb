# frozen_string_literal: true

# Application contains the application definition
#
# This loads config file into memory and creates the routes
class Application
  MODE_READING = 'reading'
  MODE_READY = 'ready'
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

    delegate :start, :endpoints, :append, :mode, to: :instance
  end

  def start
    routes.each(&:apply)
    @mode = MODE_READY
    save_file
  end

  def mode
    @mode ||= MODE_READING
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

  def save_file
    return if File.exists?(config_file_path)
    create_config_folder
    File.open(config_file_path, "w") do |file|
      file.write(config.json.to_yaml)
    end
  end

  def create_config_folder
    return unless config_folder
    return if File.exist?(config_folder)

    FileUtils.mkdir_p(config_folder)
  end

  def config_folder
    @config_folder ||= config_file_path.gsub(%r{/[^/]*$}, '')
  end
end
