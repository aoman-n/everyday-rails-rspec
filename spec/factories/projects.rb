FactoryBot.define do

  # 継承を利用したファクトリ
  # factory :project do
  #   sequence(:name) { |n| "Test Project #{n}" }
  #   description "Sample project for testing purposes"
  #   due_on 1.week.from_now
  #   association :owner

  #   factory :project_due_yesterday do
  #     due_on 1.day.ago
  #   end

  #   factory :project_due_today, class: Project do
  #     due_on Date.current.in_time_zone
  #   end

  #   factory :project_due_tomorrow, class: Project do
  #     due_on 1.day.from_now
  #   end
  # end

  # traitを利用したファクトリ
  factory :project do
    sequence(:name) { |n| "Test Project #{n}" }
    description "Sample project for testing purposes"
    due_on 1.week.from_now
    association :owner

    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project) }
    end

    trait :project_due_yesterday do
      due_on 1.day.ago
    end

    trait :project_due_today do
      due_on Date.current.in_time_zone
    end

    trait :project_due_tomorrow do
      due_on 1.day.from_now
    end
  end

end
