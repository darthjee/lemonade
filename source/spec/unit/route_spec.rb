# frozen_string_literal: true

require 'spec_helper'

describe Route do
  subject(:route) { described_class.new(attributes) }

  let(:path)       { "/route/#{SecureRandom.hex(16)}" }
  let(:content)    { "Content: #{SecureRandom.hex(16)}" }
  let(:attributes) { { path: path, content: content } }

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
      let(:http_methods) { %i[get post patch put] }
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
