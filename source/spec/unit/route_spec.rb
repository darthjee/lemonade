# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/Semicolon
describe Route, type: :controller do
  subject(:route) { described_class.new(attributes) }

  let(:app)        { Sinatra::Application }
  let(:path)       { "/route/#{SecureRandom.hex(16)}" }
  let(:content)    { "Content: #{SecureRandom.hex(16)}" }
  let(:attributes) { { path: path, content: content } }

  describe '#apply' do
    it 'builds the route' do
      expect { route.apply }
        .to change { get(path); last_response.status }
        .from(404).to(200)
    end

    it 'builds the route with content' do
      expect { route.apply }
        .to change { get(path); last_response.body }
        .to(content)
    end

    context 'when there was already another route for other endpoint' do
      let(:old_content) { "Old Content: #{SecureRandom.hex(16)}" }
      let(:old_path)    { "/route/#{SecureRandom.hex(16)}" }

      let(:previous_route) do
        build(:route, path: old_path, content: old_content)
      end

      before { previous_route.apply }

      it 'builds a new route' do
        expect { route.apply }
          .to change { get(path); last_response.status }
          .from(404).to(200)
      end

      it 'does not remove the old route' do
        expect { route.apply }
          .not_to(change { get(old_path); last_response.status })
      end

      it 'builds the route with new content' do
        expect { route.apply }
          .to change { get(path); last_response.body }
          .to(content)
      end

      it 'does not change old route content' do
        expect { route.apply }
          .not_to(change { get(old_path); last_response.body })
      end

      it 'does not disable previous route' do
        expect { route.apply }
          .not_to change(previous_route, :disabled?)
      end
    end

    context 'when there was already another route for the same endpoint' do
      let(:old_content) { "Old Content: #{SecureRandom.hex(16)}" }

      let(:previous_route) { build(:route, path: path, content: old_content) }

      before { previous_route.apply }

      it 'rebuilds the same route' do
        expect { route.apply }
          .not_to(change { get(path); last_response.status })
      end

      it 'builds the route with new content' do
        expect { route.apply }
          .to change { get(path); last_response.body }
          .from(old_content)
          .to(content)
      end

      it 'disables previous route' do
        expect { route.apply }
          .to change(previous_route, :disabled?)
          .from(nil).to(true)
      end
    end

    context 'when there was already a route for the path and another method' do
      let(:old_content) { "Old Content: #{SecureRandom.hex(16)}" }

      let(:previous_route) do
        build(:route, path: path, content: old_content, http_method: :post)
      end

      before { previous_route.apply }

      it 'builds the new route' do
        expect { route.apply }
          .to change { get(path); last_response.status }
          .from(404).to(200)
      end

      it 'builds the route with new content' do
        expect { route.apply }
          .to change { get(path); last_response.body }
          .to(content)
      end

      it 'does not disable previous route' do
        expect { route.apply }
          .not_to change(previous_route, :disabled?)
      end
    end
  end

  describe '#path' do
    it do
      expect(route.path).to eq(path)
    end
  end

  describe '#content' do
    it do
      expect(route.content).to eq(content)
    end
  end

  describe '#http_method' do
    it do
      expect(route.http_method).to be(:get)
    end

    context 'when http_method is given' do
      let(:http_methods) { %i[post patch put] }
      let(:http_method)  { http_methods.sample }
      let(:attributes) do
        { path: path, content: content, http_method: http_method }
      end

      it do
        expect(route.http_method).to eq(http_method)
      end
    end
  end
end
# rubocop:enable Style/Semicolon
