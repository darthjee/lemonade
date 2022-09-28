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

    folder = path.gsub(%r{/[^/]*$}, '')

    FileUtils.mkdir_p(folder) if folder && !File.exist?(folder)

    FileUtils.cp(SAMPLE_CONFIG, path)
    path
  end
end
