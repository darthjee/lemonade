require 'spec_helper'

describe 'GET /', type: :controller do
  let(:app) { Sinatra::Application }

  before { get '/' }

  it do
    expect(last_response).to be_successful
  end
end
