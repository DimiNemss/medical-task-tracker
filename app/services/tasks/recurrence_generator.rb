module Tasks
  class RecurrenceGenerator
    def initialize(task, from:, to:)
      @task = task
      @from = from
      @to = to
    end

    def call
      return [single_occurrence] if task.recurrence_type.nil?
      return [single_occurrence] if task.recurrence_type_none?

      generate_occurrences
    end

    private

    attr_reader :task, :from, :to

    def single_occurrence
      build_occurrence(task.due_date)
    end

    def generate_occurrences
      case task.recurrence_type
      when "daily"
        generate_daily
      when "monthly"
        generate_monthly
      when "specific_dates"
        generate_specific_dates
      when "even_days"
        generate_even_odd(:even?)
      when "odd_days"
        generate_even_odd(:odd?)
      else
        []
      end
    end

    def generate_daily
      interval = task.interval_value || 1

      occurrences = []

      current_date = task.due_date

      while current_date <= effective_end_date
        if current_date >= from
          occurrences << build_occurrence(current_date)
        end

        current_date += interval.days
      end

      occurrences
    end

    def generate_monthly
      occurrences = []

      current_date = from

      while current_date <= effective_end_date
        if current_date.day == task.monthly_day
          occurrences << build_occurrence(current_date)
        end

        current_date += 1.day
      end

      occurrences
    end

    def generate_specific_dates
      task.specific_dates.map do |date|
        next if date < from
        next if date > effective_end_date

        build_occurrence(date)
      end.compact
    end

    def generate_even_odd(method_name)
      occurrences = []

      current_date = from

      while current_date <= to
        if current_date.day.public_send(method_name)
          occurrences << build_occurrence(current_date)
        end

        current_date += 1.day
      end

      occurrences
    end

    def build_occurrence(date)
      occurrence = task.task_occurrences.find_by(
        occurrence_date: date
      )

      return if occurrence&.cancelled?

      actual_date =
        occurrence&.overridden_due_date || date

      {
        date: actual_date,

        status:
          occurrence&.status || task.status,

        task_id: task.id,

        title:
          occurrence&.title_override ||
          task.title,

        description:
          occurrence&.description_override ||
          task.description,

        detached:
          occurrence&.detached || false
      }
    end

    def effective_end_date
      [to, task.ends_at].compact.min
    end
  end
end