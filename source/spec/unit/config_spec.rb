# frozen_string_literal: true

require 'spec_helper'

describe Config do
  let(:file_path) { fixture_file_path('sample_routes.yml') }

  describe '.load_file' do
    subject(:config) { described_class.load_file(file_path) }

    it do
      expect(config).to be_a(described_class)
    end

    it do
      expect(config.routes).not_to be_empty
    end

    it do
      expect(config.routes).to all(be_a(Route))
    end
  end
end
