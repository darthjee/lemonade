# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/Semicolon
describe Application, type: :controller do
  before { described_class.config_file_path(config_path) }

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

    context 'when the neither file nor folder do not exist' do
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
# rubocop:enable Style/Semicolon
