# frozen_string_literal: true

# Application contains the application definition
#
# This loads config file into memory and creates the routes
module Application
  class << self
    def config_file_path(path = @config_file_path)
      @config_file_path = path
    end

    def start
      config.routes.each(&:apply)
    end

    private

    def config
      Config.load_file(config_file_path)
    end
  end
end
