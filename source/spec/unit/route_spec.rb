# frozen_string_literal: true

require 'spec_helper'

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
        .from(404)
        .to(200)
    end

    it 'builds the route with content' do
      expect { route.apply }
        .to change { get(path); last_response.body }
        .to(content)
    end

    context 'when there was already another route' do
      let(:old_content) { "Old Content: #{SecureRandom.hex(16)}" }

      before do
        described_class.new(path: path, content: old_content).apply
      end

      it 'rebuilds the same route' do
        expect { route.apply }
          .not_to change { get(path); last_response.status }
      end

      it 'builds the route with new content' do
        expect { route.apply }
          .to change { get(path); last_response.body }
          .from(old_content)
          .to(content)
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
