# frozen_string_literal: true

require 'spec_helper'

describe Application, type: :controller do
  before do
    described_class.reset
    described_class.config_file_path(config_path)
  end

  describe '.endpoints' do
    let(:config_path) do
      fixture_file_path('test_normalization.yml')
    end

    context 'when application has not been started' do
      it do
        expect(described_class.endpoints).to eq({})
      end
    end

    context 'when application has been started' do
      let(:expected_endpoints) do
        {
          'get:/a_normal_path' => instance_of(Endpoint),
          'patch:/update/:var' => instance_of(Endpoint)
        }
      end

      before { described_class.start }

      it 'maps endpoints to a normalized path' do
        expect(described_class.endpoints)
          .to match(expected_endpoints)
      end

      it 'uses normalized endpoint as key' do
        described_class.endpoints.each do |key, endpoint|
          expect(endpoint.normalized_endpoint).to eq(key)
        end
      end
    end
  end

  describe '.start' do
    context 'when the config file exists' do
      let(:app) { Sinatra::Application }
      let(:path) { '/test_path' }
      let(:config_path) do
        fixture_file_path('test_application_routes.yml')
      end

      it 'creates endpoints' do
        expect { described_class.start }
          .to change { get(path); last_response.status }
          .from(404)
          .to(200)
      end
    end

    context 'when neither file nor folder do exist' do
      let(:config_file)   { "#{SecureRandom.hex(10)}.yml" }
      let(:config_folder) { "/tmp/#{SecureRandom.hex(10)}" }

      let(:config_path) do
        "#{config_folder}/#{config_file}"
      end

      after { FileUtils.rm_rf(config_folder) }

      it 'creates a config file' do
        expect { described_class.start }
          .to change { Dir[config_path] }
          .from([])
          .to([config_path])
      end

      it 'creates a config folder' do
        expect { described_class.start }
          .to change { Dir[config_folder] }
          .from([])
          .to([config_folder])
      end
    end
  end
end
