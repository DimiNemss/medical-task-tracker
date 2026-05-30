require "swagger_helper"

RSpec.describe "API::V1::Tasks", type: :request do
  path "/api/v1/tasks" do
    get "List tasks" do
      tags "Tasks"

      produces "application/json"

      parameter name: :status,
                in: :query,
                type: :string,
                required: false,
                description: "Filter by status"

      parameter name: :from,
                in: :query,
                type: :string,
                required: false,
                description: "Start due date"

      parameter name: :to,
                in: :query,
                type: :string,
                required: false,
                description: "End due date"

      parameter name: :page,
                in: :query,
                type: :integer,
                required: false,
                description: "Pagination page"

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
              title: {
                type: :string
              },

              description: {
                type: :string
              },

              status: {
                type: :string,
                enum: %w[pending completed cancelled]
              },

              due_date: {
                type: :string,
                format: :date
              },

              recurrence_type: {
                type: :string,
                enum: %w[
                  none
                  daily
                  monthly
                  specific_dates
                  even_days
                  odd_days
                ]
              },

              interval_value: {
                type: :integer
              },

              monthly_day: {
                type: :integer
              },

              ends_at: {
                type: :string,
                format: :date
              },

              specific_dates: {
                type: :array,
                items: {
                  type: :string,
                  format: :date
                }
              }
            },
            required: %w[title due_date]
          }
        }
      }

      response "201", "task created" do
        let(:task) do
          {
            task: {
              title: "Daily patient calls",
              description: "Call patients",

              status: "pending",

              due_date: "2026-05-30",

              recurrence_type: "daily",

              interval_value: 2,

              ends_at: "2026-12-31"
            }
          }
        end

        run_test!
      end
    end
  end

  path "/api/v1/tasks/{id}" do
    parameter name: :id,
              in: :path,
              type: :integer

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

    patch "Update task" do
      tags "Tasks"

      consumes "application/json"
      produces "application/json"

      parameter name: :task,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    task: {
                      type: :object,
                      properties: {
                        title: {
                          type: :string
                        },

                        description: {
                          type: :string
                        },

                        status: {
                          type: :string,
                          enum: %w[pending completed cancelled]
                        },

                        due_date: {
                          type: :string,
                          format: :date
                        },

                        recurrence_type: {
                          type: :string,
                          enum: %w[
                            none
                            daily
                            monthly
                            specific_dates
                            even_days
                            odd_days
                          ]
                        },

                        interval_value: {
                          type: :integer
                        },

                        monthly_day: {
                          type: :integer
                        },

                        ends_at: {
                          type: :string,
                          format: :date
                        },

                        specific_dates: {
                          type: :array,
                          items: {
                            type: :string,
                            format: :date
                          }
                        }
                      }
                    }
                  }
                }

      response "200", "task updated" do
        let!(:task_record) do
          Task.create!(
            title: "Old title",
            description: "Old description",
            status: :pending,
            due_date: Date.today
          )
        end

        let(:id) { task_record.id }

        let(:task) do
          {
            task: {
              title: "Updated title",
              recurrence_type: "daily",
              interval_value: 3
            }
          }
        end

        run_test!
      end
    end

    delete "Delete task" do
      tags "Tasks"

      produces "application/json"

      response "204", "task deleted" do
        let!(:task_record) do
          Task.create!(
            title: "Delete me",
            description: "Delete me",
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