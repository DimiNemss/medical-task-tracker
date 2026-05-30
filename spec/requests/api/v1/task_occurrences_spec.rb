require "swagger_helper"

RSpec.describe "Task Occurrences API", type: :request do
  path "/api/v1/tasks/{task_id}/occurrences/{occurrence_date}" do
    patch "Update occurrence" do
      tags "Occurrences"

      consumes "application/json"
      produces "application/json"

      parameter name: :task_id,
                in: :path,
                type: :integer

      parameter name: :occurrence_date,
                in: :path,
                type: :string,
                format: :date,
                description: "Occurrence date"

      parameter name: :occurrence_data,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    status: {
                      type: :string,
                      enum: %w[
                        pending
                        completed
                        cancelled
                      ]
                    },

                    overridden_due_date: {
                      type: :string,
                      format: "date-time"
                    },

                    detached: {
                      type: :boolean
                    },

                    title_override: {
                      type: :string
                    },

                    description_override: {
                      type: :string
                    }
                  }
                }

      response "200", "successful" do
        let!(:task) do
          Task.create!(
            title: "Daily round",
            description: "Test",
            status: :pending,
            due_date: Date.current,
            recurrence_type: :daily
          )
        end

        let(:task_id) do
          task.id
        end

        let(:occurrence_date) do
          Date.current.to_s
        end

        let(:occurrence_data) do
          {
            status: "completed",
            detached: true,
            title_override: "Emergency ICU Round",
            description_override:
              "Check post-operative patients",

            overridden_due_date:
              "#{Date.current}T11:00:00"
          }
        end

        run_test!
      end
    end
  end
end