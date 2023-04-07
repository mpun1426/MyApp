FactoryBot.define do
  factory :spot do
    name { "スポット" }
    address { "都道府県" }
    feature { "特徴的" }
    describe { "説明文" }
    association :user
  end
end
