# frozen_string_literal: true

require 'spec_helper'

describe ConfigLoader do
  let(:file_path) { fixture_file_path('sample_routes.yml') }

  describe '#load' do
    subject(:loader) { described_class.new(file_path) }

    context 'when the file exists and LEMONADE_CONFIG is nil' do
      it do
        expect(loader.load).to be_a(Hash)
      end

      it 'has routes' do
        expect(loader.load['routes']).not_to be_empty
      end
    end

    context 'when LEMONADE_CONFIG env is set and file does not exist' do
      let(:file_path) { "/tmp/routes_#{SecureRandom.hex(10)}.yml" }
      let(:expected_config) { JSON.parse(config_json) }

      let(:config_json) do
        {
          routes: [{
            path: "/path/#{SecureRandom.hex(10)}",
            content: SecureRandom.hex(10)
          }]
        }.to_json
      end

      before { ENV['LEMONADE_CONFIG'] = config_json }

      after { ENV['LEMONADE_CONFIG'] = nil }

      it do
        expect(loader.load).to be_a(Hash)
      end

      it 'loads config from env' do
        expect(loader.load).to match(expected_config)
      end
    end

    context 'when the file does not exist and LEMONADE_CONFIG is nil' do
      let(:file_path)       { "/tmp/#{SecureRandom.hex(10)}.yml" }
      let(:expected_config) { YAML.load_file(described_class::SAMPLE_CONFIG) }

      it 'loads config from sample file' do
        expect(loader.load).to match(expected_config)
      end
    end
  end
end
