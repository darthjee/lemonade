class ConfigLoader
  def initialize(path)
    @path = path
  end

  def load
    YAML.load_file(path)
  end

  private

  attr_reader :path
end
