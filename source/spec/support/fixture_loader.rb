# frozen_string_literal: true

module FixtureLoader
  def fixture_file_path(path)
    [root_fixture_path, path].join('/').gsub('//', '/')
  end

  def load_fixture_yml(path)
    YAML.load_file(fixture_file_path(path))
  end

  def load_fixture_file(path)
    File.read(fixture_file_path(path))
  end

  def root_fixture_path
    @root_path = [
      File.expand_path(__dir__),
      'fixtures'
    ].join('/').gsub('//', '/')
  end
end
