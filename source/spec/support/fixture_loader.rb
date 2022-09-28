module FixtureLoader
  def fixture_file_path(path)
    [root_fixture_path, path].join('/').gsub('//', '/')
  end

  def root_fixture_path
    @root_path = [
      File.expand_path(__dir__),
      'fixtures',
    ].join('/').gsub('//', '/')
  end
end
