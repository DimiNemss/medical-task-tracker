class TaskOccurrence < ApplicationRecord
  belongs_to :task

  enum :status, {
    pending: 0,
    completed: 1,
    cancelled: 2
  }

  validates :occurrence_date, presence: true

  def detached?
    detached
  end
end