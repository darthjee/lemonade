# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/Semicolon
describe Endpoint, type: :controller do
  let(:app) { Sinatra::Application }

  let(:path)    { "/route/#{SecureRandom.hex(16)}" }
  let(:content) { "Content: #{SecureRandom.hex(16)}" }
  let(:route)   { Route.new(path: path, content: content) }

  describe '.build' do
    it 'creates endpoint' do
      expect { described_class.build(route) }
        .to change { get(path); last_response.status }
        .from(404)
        .to(200)
    end

    it 'creates endpoint with content' do
      expect { described_class.build(route) }
        .to change { get(path); last_response.body }
        .to(content)
    end
  end
end
# rubocop:enable Style/Semicolon
