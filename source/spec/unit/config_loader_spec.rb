# frozen_string_literal: true

require 'spec_helper'

describe ConfigLoader do
  let(:file_path) { fixture_file_path('sample_routes.yml') }

  describe '#load' do
    subject(:loader) { described_class.new(file_path) }

    it do
      expect(loader.load).to be_a(Hash)
    end

    it 'has routes' do
      expect(loader.load['routes']).not_to be_empty
    end
  end
end

