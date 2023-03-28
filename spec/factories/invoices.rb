FactoryBot.define do
  factory :invoice do
    customer_id {Faker::Number.within(range: 1..174)}
    merchant_id {Faker::Number.within(range: 1..100)}
    status { [0, 1, 2].shuffle.first }
  end
end
