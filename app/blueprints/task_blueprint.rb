class TaskBlueprint < Blueprinter::Base
  identifier :id

	fields :title,
				:description,
				:status,
				:due_date,

				:recurrence_type,
				:interval_value,
				:monthly_day,
				:ends_at,
				:specific_dates,

				:created_at,
				:updated_at

  association :tags,
              blueprint: TagBlueprint
end