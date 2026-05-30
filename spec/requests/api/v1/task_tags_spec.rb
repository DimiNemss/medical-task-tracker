require "swagger_helper"

RSpec.describe "API::V1::TaskTags", type: :request do
  path "/api/v1/tasks/{task_id}/tags" do
    post "Attach tag to task" do
      tags "Task Tags"

      consumes "application/json"
      produces "application/json"

      parameter name: :task_id,
                in: :path,
                type: :integer

      parameter name: :tag_data,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    tag_id: {
                      type: :integer
                    }
                  },
                  required: ["tag_id"]
                }

      response "200", "successful" do
        let!(:task) do
          Task.create!(
            title: "Test task",
            description: "Test",
            status: :pending,
            due_date: Date.current
          )
        end

        let!(:tag) do
          Tag.create!(
            name: "test-tag"
          )
        end

        let(:task_id) { task.id }

        let(:tag_data) do
          {
            tag_id: tag.id
          }
        end

        run_test!
      end
    end
  end

  path "/api/v1/tasks/{task_id}/tags/{tag_id}" do
    delete "Remove tag from task" do
      tags "Task Tags"

      produces "application/json"

      parameter name: :task_id,
                in: :path,
                type: :integer

      parameter name: :tag_id,
                in: :path,
                type: :integer

      response "200", "successful" do
        let!(:task) do
          Task.create!(
            title: "Test task",
            description: "Test",
            status: :pending,
            due_date: Date.current
          )
        end

        let!(:tag) do
          Tag.create!(
            name: "test-tag"
          )
        end

        before do
          task.tags << tag
        end

        let(:task_id) { task.id }
        let(:tag_id) { tag.id }

        run_test!
      end
    end
  end
end