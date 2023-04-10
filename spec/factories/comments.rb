FactoryBot.define do
  factory :comment do
    content { "コメント本文" }
    user_id { nil }
    spot_id { nil }
  end
end
