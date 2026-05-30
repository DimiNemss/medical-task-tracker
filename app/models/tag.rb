class Tag < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags

  validates :name,
            presence: true,
            uniqueness: true

  before_update :prevent_system_update
  before_destroy :prevent_system_destroy

  private

  def prevent_system_update
    return unless system?

    errors.add(
      :base,
      "System tags cannot be modified"
    )

    throw(:abort)
  end

  def prevent_system_destroy
    return unless system?

    errors.add(
      :base,
      "System tags cannot be deleted"
    )

    throw(:abort)
  end
end