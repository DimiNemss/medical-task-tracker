class Task < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags
  has_many :task_occurrences, dependent: :destroy

  enum :status, {
    pending: 0,
    completed: 1,
    cancelled: 2
  }

  enum :recurrence_type, {
    none: 0,
    daily: 1,
    monthly: 2,
    specific_dates: 3,
    even_days: 4,
    odd_days: 5
  }, prefix: true

  validates :title, presence: true
  validates :due_date, presence: true
  validates :interval_value,
          presence: true,
          if: :recurrence_type_daily?

  validates :monthly_day,
            presence: true,
            inclusion: { in: 1..31 },
            if: :recurrence_type_monthly?

  validates :specific_dates,
            presence: true,
            if: :recurrence_type_specific_dates?
end