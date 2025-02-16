FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    is_deleted { false }
    is_archived { false }
    association :user
  end

  factory :archived_note, parent: :note do
    title { "Archived Note" }
    content { "Archived content" }
    is_archived { true }
  end

  factory :deleted_note, parent: :note do
    title { "Deleted Note" }
    content { "Deleted content" }
    is_deleted { true }
  end
end
