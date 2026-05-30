module Api
  module V1
    class TaskOccurrencesController < BaseController
      def update
        task = Task.find(params[:task_id])

        occurrence =
          task.task_occurrences.find_or_initialize_by(
            occurrence_date: params[:occurrence_date]
          )

        if occurrence.update(occurrence_params)
          render_success(
            {
              task_id: task.id,
              date: occurrence.occurrence_date,
              status: occurrence.status,
              detached: occurrence.detached,
              title_override: occurrence.title_override,
              description_override:
                occurrence.description_override,
              overridden_due_date:
                occurrence.overridden_due_date
            }
          )
        else
          render_error(
            occurrence.errors.full_messages
          )
        end
      end

      private

      def occurrence_params
        params.permit(
          :status,
          :detached,
          :title_override,
          :description_override,
          :overridden_due_date
        )
      end
    end
  end
end