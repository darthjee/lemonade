# frozen_string_literal: true

# Class responsible for loading the raw config
#
# When loading, if the config file does not exist, it
# is created as a copy from 'resource/routes.yml'
class ConfigLoader
  SAMPLE_CONFIG = 'resource/routes.yml'

  def initialize(path)
    @path = path
  end

  def load
    config_from_env || config_from_file
  end

  private

  attr_reader :path

  def config_from_file
    YAML.load_file(config_file_path)
  end

  def config_from_env
    return unless ENV['LEMONADE_CONFIG'].present?

    JSON.parse(ENV['LEMONADE_CONFIG'])
  end

  def config_file_path
    return path if File.exist?(path)

    SAMPLE_CONFIG
  end
end
