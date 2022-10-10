# frozen_string_literal: true

require 'spec_helper'

describe Endpoint, type: :controller do
  let(:app) { Sinatra::Application }

  let(:path)    { route.path }
  let(:content) { route.content }
  let(:route)   { build(:route) }

  describe '.build' do
    it 'creates endpoint' do
      expect { described_class.build(route) }
        .to change { get(path); last_response.status }
        .from(404).to(200)
    end

    it 'creates endpoint with content' do
      expect { described_class.build(route) }
        .to change { get(path); last_response.body }
        .to(content)
    end
  end

  describe '#update' do
    subject(:endpoint) { create(:endpoint) }
    let(:old_route) { endpoint.route }
    let(:route) { create(:route) }

    it do
      expect { endpoint.update(route) }
        .to change(old_route, :disabled?)
        .from(nil).to(true)
    end

    it do
      expect { endpoint.update(route) }
        .not_to change(route, :disabled?)
    end

    it do
      expect { endpoint.update(route) }
        .to change(endpoint, :route)
        .from(old_route).to(route)
    end
  end
end
