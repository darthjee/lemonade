# frozen_string_literal: true

# Loads and stores config from config folder
class Config
  include Arstotzka

  def self.load_file(file_path)
    new(ConfigLoader.new(file_path).load)
  end

  attr_reader :json
  expose :routes, klass: ::Route

  def initialize(json = {})
    @json = json
  end
end
