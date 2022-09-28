# frozen_string_literal: true

# Application contains the application definition
#
# This loads config file into memory and creates the routes
module Application
  class << self
    def start
      config.routes.each(&:apply)
    end

    private

    def config
      @config ||= Config.load_file('config/routes.yml')
    end
  end
end
