# frozen_string_literal: true

require 'spec_helper'

describe 'GET /', type: :controller do
  let(:app) { Sinatra::Application }

  before { get '/' }

  it do
    expect(last_response).to be_successful
  end

  it do
    expect(last_response.body).to eq('I am up')
  end
end
