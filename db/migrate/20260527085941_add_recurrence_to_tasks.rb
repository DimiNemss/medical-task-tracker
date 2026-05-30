class AddRecurrenceToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :recurrence_type, :integer
    add_column :tasks, :interval_value, :integer
    add_column :tasks, :monthly_day, :integer
    add_column :tasks, :ends_at, :date

    add_column :tasks,
               :specific_dates,
               :date,
               array: true,
               default: []
  end
end