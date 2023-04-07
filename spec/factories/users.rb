FactoryBot.define do
  factory :user do
    nickname { "ほげほげ" }
    sequence(:email) { |n| "hoge#{n}@sample.email" }
    password { "password" }
    password_confirmation { "password" }
    introduction { "よろしく" }
  end
end
