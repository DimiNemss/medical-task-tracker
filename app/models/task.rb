class Task < ApplicationRecord
  enum :status, {
    pending: 0,
    completed: 1,
    cancelled: 2
  }

  validates :title, presence: true
  validates :due_date, presence: true
  validates :status, presence: true
end