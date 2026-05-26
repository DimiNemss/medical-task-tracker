class Task < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  enum :status, {
    pending: 0,
    completed: 1,
    cancelled: 2
  }

  validates :title, presence: true
  validates :due_date, presence: true
  validates :status, presence: true
end