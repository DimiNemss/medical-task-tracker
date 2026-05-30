class TaskBlueprint < Blueprinter::Base
  identifier :id

  fields :title,
         :description,
         :status,
         :due_date,
         :created_at,
         :updated_at
end