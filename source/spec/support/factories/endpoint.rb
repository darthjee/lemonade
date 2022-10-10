# frozen_string_literal: true

FactoryBot.define do
  factory :endpoint, class: 'endpoint' do
    skip_create

    initialize_with do
      Endpoint.new(route)
    end

    transient do
      route { create(:route, path: path, http_method: http_method) }
      path    { "/route/#{SecureRandom.hex(16)}" }
      http_method { :get }
    end
  end
end
