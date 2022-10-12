FactoryBot.define do
  factory :todo do
    title { ["clean", "tidy up"].sample + ' ' + Faker::House.room }
    status { [:incomplete, :complete].sample }
  end
end
