require "swagger_helper"

RSpec.describe "API::V1::Tasks", type: :request do
  path "/api/v1/tasks" do
    get "List tasks" do
      tags "Tasks"

      produces "application/json"

      response "200", "successful" do
        before do
          Task.create!(
            title: "Call patient",
            description: "Confirm appointment",
            status: :pending,
            due_date: Date.today
          )
        end

        run_test!
      end
    end

    post "Create task" do
      tags "Tasks"

      consumes "application/json"
      produces "application/json"

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              status: { type: :string },
              due_date: { type: :string, format: :date }
            },
            required: %w[title due_date]
          }
        }
      }

      response "201", "task created" do
        let(:task) do
          {
            task: {
              title: "Call patient",
              description: "Confirm appointment",
              status: "pending",
              due_date: "2026-05-30"
            }
          }
        end

        run_test!
      end
    end
  end

  path "/api/v1/tasks/{id}" do
    parameter name: :id, in: :path, type: :integer

    get "Show task" do
      tags "Tasks"

      produces "application/json"

      response "200", "successful" do
        let!(:task_record) do
          Task.create!(
            title: "Test task",
            description: "Description",
            status: :pending,
            due_date: Date.today
          )
        end

        let(:id) { task_record.id }

        run_test!
      end
    end
  end
end