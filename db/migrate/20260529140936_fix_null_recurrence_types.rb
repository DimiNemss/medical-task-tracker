class FixNullRecurrenceTypes < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE tasks
      SET recurrence_type = 0
      WHERE recurrence_type IS NULL
    SQL

    change_column_default :tasks,
                          :recurrence_type,
                          0
  end

  def down
    change_column_default :tasks,
                          :recurrence_type,
                          nil
  end
end