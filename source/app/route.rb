# frozen_string_literal: true

# Route configuration
class Route
  include Arstotzka

  attr_reader :json
  expose :path
  expose :content
  expose :http_method, type: :symbol, default: :get, case: :snake

  def initialize(json = {})
    @json = json
  end

  def apply
    Endpoint.build(self)
  end

  def disabled?
    @disabled
  end

  def disable!
    @disabled = true
  end

  def normalized_endpoint
    "#{http_method}:#{normalized_path}"
  end

  def same?(other)
    return false if other === self
    return false unless other.is_a?(Route)
    return false unless http_method == other.http_method
    return true if path == other.path
    normalized_path == other.normalized_path
  end

  protected

  def normalized_path
    @normalized_path ||= path.gsub(/:[^\/]*/, ':var')
  end
end
