# frozen_string_literal: true

require 'spec_helper'

describe Route, type: :controller do
  subject(:route) { described_class.new(attributes) }

  let(:app)         { Sinatra::Application }
  let(:path)        { "/route/#{SecureRandom.hex(16)}" }
  let(:content)     { "Content: #{SecureRandom.hex(16)}" }
  let(:http_method) { :get }
  let(:attributes) do
    { path: path, content: content, http_method: http_method }
  end

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
      let(:previous_route) { build(:route) }
      let(:old_path)       { previous_route.path }

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

      it 'creates a new endpoint' do
        expect { route.apply }
          .to change { Application.endpoints.keys }
          .by([route.normalized_endpoint])
      end
    end

    context 'when there was already another route for the same endpoint' do
      let(:old_content) { previous_route.content }
      let(:previous_route) { build(:route, path: path) }
      let(:endpoint) { Application.endpoints[route.normalized_endpoint] }

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

      it 'does not create a new endpoint' do
        expect { route.apply }
          .not_to(change { Application.endpoints.keys })
      end

      it 'changes route inside the endpoint' do
        expect { route.apply }
          .to change(endpoint, :route)
          .from(previous_route).to(route)
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

      it 'creates a new endpoint' do
        expect { route.apply }
          .to change { Application.endpoints.keys }
          .by([route.normalized_endpoint])
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

  describe '#normalized_endpoint' do
    context 'when the path has no variables' do
      let(:http_methods) { %i[get post patch put delete] }
      let(:http_method) { http_methods.sample }
      let(:path) { "/route/#{SecureRandom.hex(32)}" }

      it 'joins http_method and path' do
        expect(route.normalized_endpoint)
          .to eq("#{http_method}:#{path}")
      end
    end

    context 'when the path has variables' do
      let(:path) { '/route/users/:user_id/documents/:id' }
      let(:expected_path) { '/route/users/:var/documents/:var' }

      it 'joins http_method and path' do
        expect(route.normalized_endpoint)
          .to eq("#{http_method}:#{expected_path}")
      end
    end
  end
end
