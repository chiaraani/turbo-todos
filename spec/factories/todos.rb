# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    title { "#{['clean', 'tidy up'].sample} #{Faker::House.room}" }
    status { %i[incomplete complete].sample }
  end
end
