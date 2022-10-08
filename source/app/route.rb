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
    Application.append(self)
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
  
  private

  def normalized_path
    @normalized_path ||= path.gsub(%r{:[^/]*}, ':var')
  end
end
