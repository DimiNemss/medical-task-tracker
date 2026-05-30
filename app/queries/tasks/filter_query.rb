module Tasks
  class FilterQuery
    def self.call(relation = Task.all, params = {})
      tasks = relation

      tasks = filter_by_status(tasks, params[:status])
      tasks = filter_by_due_date(tasks, params[:from], params[:to])

      tasks
    end

    class << self
      private

      def filter_by_status(tasks, status)
        return tasks if status.blank?

        tasks.where(status: status)
      end

      def filter_by_due_date(tasks, from, to)
        return tasks if from.blank? || to.blank?

        tasks.where(due_date: from..to)
      end
    end
  end
end