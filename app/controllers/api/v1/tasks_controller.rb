module Api
  module V1
    class TasksController < BaseController
      def index
        tasks = Task.order(created_at: :desc)

        tasks = tasks.where(status: params[:status]) if params[:status].present?

        if params[:from].present? && params[:to].present?
          tasks = tasks.where(
            due_date: params[:from]..params[:to]
          )
        end

        render_success(
          TaskBlueprint.render_as_hash(tasks)
        )
      end

      def show
        task = find_task

        render_success(
          TaskBlueprint.render_as_hash(task)
        )
      end

      def create
        task = Task.new(task_params)

        if task.save
          render_success(
            TaskBlueprint.render_as_hash(task),
            status: :created
          )
        else
          render_error(task.errors.full_messages)
        end
      end

      def update
        task = find_task

        if task.update(task_params)
          render_success(
            TaskBlueprint.render_as_hash(task)
          )
        else
          render_error(task.errors.full_messages)
        end
      end

      def destroy
        task = find_task

        task.destroy

        head :no_content
      end

      private

      def find_task
        Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(
          :title,
          :description,
          :status,
          :due_date
        )
      end
    end
  end
end