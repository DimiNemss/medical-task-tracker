class CreateTaskOccurrences < ActiveRecord::Migration[8.1]
  def change
    create_table :task_occurrences do |t|
      t.references :task, null: false, foreign_key: true
      t.date :occurrence_date, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :task_occurrences,
              [:task_id, :occurrence_date],
              unique: true
  end
end