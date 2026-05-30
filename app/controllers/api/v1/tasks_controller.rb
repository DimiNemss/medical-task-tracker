module Api
  module V1
    class TasksController < BaseController
      def index
        tasks = Task.order(created_at: :desc)

        occurrences = generate_occurrences(tasks)

        occurrences = filter_occurrences(
          occurrences,
          params
        )

        occurrences = sort_occurrences(
          occurrences
        )

        @pagy, occurrences =
          pagy_array(
            occurrences,
            page: params[:page]
          )

        render_success(
          {
            data:
              TaskOccurrenceBlueprint.render_as_hash(
                occurrences
              ),
            meta: {
              page: @pagy.page,
              per_page: @pagy.limit,
              total_pages: @pagy.pages,
              total_count: @pagy.count
            }
          }
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
          render_error(
            task.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def update
        task = find_task

        if task.update(task_params)
          render_success(
            TaskBlueprint.render_as_hash(task)
          )
        else
          render_error(
            task.errors.full_messages,
            status: :unprocessable_entity
          )
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
          :due_date,

          :recurrence_type,
          :interval_value,
          :monthly_day,
          :ends_at,

          specific_dates: []
        )
      end

      def generate_occurrences(tasks)
        from =
          parse_date(params[:from]) ||
          Date.current

        to =
          parse_date(params[:to]) ||
          Date.current + 30.days

        tasks.flat_map do |task|
          Tasks::RecurrenceGenerator.new(
            task,
            from: from,
            to: to
          ).call
        end.compact
      end

      def parse_date(value)
        return if value.blank?

        Date.parse(value)
      end

      def filter_occurrences(
        occurrences,
        params
      )
        occurrences =
          filter_by_status(
            occurrences,
            params[:status]
          )

        occurrences =
          filter_by_date(
            occurrences,
            params[:from],
            params[:to]
          )

        occurrences
      end

      def filter_by_status(
        occurrences,
        status
      )
        return occurrences if status.blank?

        occurrences.select do |occurrence|
          occurrence[:status] == status
        end
      end

      def filter_by_date(
        occurrences,
        from,
        to
      )
        return occurrences if from.blank? || to.blank?

        from_date = Date.parse(from)
        to_date = Date.parse(to)

        occurrences.select do |occurrence|
          occurrence[:date].between?(
            from_date,
            to_date
          )
        end
      end

      def sort_occurrences(
        occurrences
      )
        occurrences.sort_by do |occurrence|
          occurrence[:date]
        end
      end
    end
  end
end