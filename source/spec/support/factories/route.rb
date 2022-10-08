# frozen_string_literal: true

FactoryBot.define do
  factory :route, class: 'Route' do
    skip_create

    initialize_with do
      Route.new(
        path: path,
        content: content,
        http_method: http_method
      )
    end

    transient do
      path    { "/route/#{SecureRandom.hex(16)}" }
      content { "Content: #{SecureRandom.hex(16)}" }
      http_method { :get }
    end
  end
end
