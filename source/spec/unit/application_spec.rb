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
    let(:app) { Sinatra::Application }

    context 'when the config file exists' do
      let(:path) { "/test_path/#{SecureRandom.hex(16)}" }
      let(:sample_config) do
        load_fixture_file('test_application_routes.yml')
      end
      let(:config_content) do
        sample_config.gsub('{random_path}', path)
      end
      let(:config_path) do
        "/tmp/#{SecureRandom.hex(16)}_routes.yml"
      end

      before do
        File.open(config_path, 'w') do |file|
          file.write(config_content)
        end
      end

      after { FileUtils.rm(config_path) }

      it 'creates endpoints' do
        expect { described_class.start }
          .to change { get(path); last_response.status }
          .from(404)
          .to(200)
      end

      it 'changes the mode' do
        expect { described_class.start }
          .to change(described_class, :mode)
          .from(described_class::MODE_READING).to(described_class::MODE_READY)
      end
    end

    context 'when neither file nor folder do exist' do
      let(:config_file)   { "#{SecureRandom.hex(10)}.yml" }
      let(:config_folder) { "/tmp/#{SecureRandom.hex(10)}" }

      let(:config_path) do
        "#{config_folder}/#{config_file}"
      end

      after { FileUtils.rm_rf(config_folder) }

      it 'loads the config file' do
        expect { described_class.start }
          .to change(described_class, :endpoints)
      end

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

    context 'when the file does not exists but LEMONADE_CONFIG is set' do
      let(:config_file)   { "#{SecureRandom.hex(10)}.yml" }
      let(:config_folder) { "/tmp/#{SecureRandom.hex(10)}" }
      let(:path)          { "/path/#{SecureRandom.hex(10)}" }

      let(:config_path) do
        "#{config_folder}/#{config_file}"
      end

      let(:config_json) do
        {
          routes: [{
            path: path,
            content: SecureRandom.hex(10)
          }]
        }.to_json
      end

      before { ENV['LEMONADE_CONFIG'] = config_json }

      #after { FileUtils.rm_rf(config_folder) }
      after { ENV['LEMONADE_CONFIG'] = nil }

      it 'creates endpoints' do
        expect { described_class.start }
          .to change { get(path); last_response.status }
          .from(404)
          .to(200)
      end

      it 'loads the config file' do
        expect { described_class.start }
          .to change(described_class, :endpoints)
      end

      xit 'creates a config file' do
        expect { described_class.start }
          .to change { Dir[config_path] }
          .from([])
          .to([config_path])
      end

      xit 'creates a config folder' do
        expect { described_class.start }
          .to change { Dir[config_folder] }
          .from([])
          .to([config_folder])
      end
    end
  end
end
