FactoryBot.define do
  factory :task_occurrence do
    task { nil }
    occurrence_date { "2026-05-27" }
    status { 1 }
  end
end
