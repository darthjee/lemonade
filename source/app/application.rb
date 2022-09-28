# frozen_string_literal: true

# Application contains the application definition
#
# This loads config file into memory and creates the routes
module Application
  SAMPLE_CONFIG = 'resource/routes.yml'

  class << self
    def config_file_path(path = @config_file_path)
      @config_file_path = path
    end

    def start
      config.routes.each(&:apply)
    end

    private

    def config
      Config.load_file(config_file)
    end

    def config_file
      return config_file_path if File.exists?(config_file_path)
      FileUtils.cp(SAMPLE_CONFIG, config_file_path)
      config_file_path
    end
  end
end
