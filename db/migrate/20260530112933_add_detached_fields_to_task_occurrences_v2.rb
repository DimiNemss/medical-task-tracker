class AddDetachedFieldsToTaskOccurrencesV2 < ActiveRecord::Migration[8.1]
  def change
    add_column :task_occurrences,
               :title_override,
               :string

    add_column :task_occurrences,
               :description_override,
               :text
  end
end
