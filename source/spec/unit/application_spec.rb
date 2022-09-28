# frozen_string_literal: true

require 'spec_helper'

describe Application do
  let(:config_file)   { "#{SecureRandom.hex(10)}.yml" }
  let(:config_folder) { "/tmp/#{SecureRandom.hex(10)}" }
  let(:config_path) do
    "#{config_folder}/#{config_file}"
  end

  before { described_class.config_file_path(config_path) }
  after  { FileUtils.rm_rf(config_folder) }

  describe '.start' do
    context 'when the neither file nor folder do not exist' do
      it 'creates a config file' do
        expect { described_class.start }
          .to change { Dir[config_path] }
          .from([])
          .to([config_path])
      end

      it 'creates a config folder' do
        expect { described_class.start }
          .to change { Dir[config_path] }
          .from([])
          .to([config_path])
      end
    end
  end
end
