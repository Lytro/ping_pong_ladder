FactoryGirl.define do
  factory :match do
    association :winner
    association :loser
  end

  factory :player, aliases: [:winner, :loser] do
    sequence(:name) { |i| "Factory Player #{i}" }
  end
end
