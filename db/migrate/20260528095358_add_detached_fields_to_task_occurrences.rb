class AddDetachedFieldsToTaskOccurrences < ActiveRecord::Migration[8.1]
  def change
    add_column :task_occurrences,
               :detached,
               :boolean,
               default: false,
               null: false

    add_column :task_occurrences,
               :overridden_due_date,
               :datetime

    add_column :task_occurrences,
               :cancelled,
               :boolean,
               default: false,
               null: false
  end
end