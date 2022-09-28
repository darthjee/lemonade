class ConfigLoader
  SAMPLE_CONFIG = 'resource/routes.yml'

  def initialize(path)
    @path = path
  end

  def load
    YAML.load_file(config_file_path)
  end

  private

  attr_reader :path

  def config_file_path
    return path if File.exist?(path)

    create_config_folder
    FileUtils.cp(SAMPLE_CONFIG, path)

    path
  end

  def create_config_folder
    return unless config_folder
    return if File.exist?(config_folder)

    FileUtils.mkdir_p(config_folder)
  end

  def config_folder
    @config_folder ||= path.gsub(%r{/[^/]*$}, '')
  end
end
