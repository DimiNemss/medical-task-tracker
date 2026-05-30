class TaskOccurrenceBlueprint < Blueprinter::Base
  fields :task_id,
         :title,
         :description,
         :date,
         :status,
         :detached
end