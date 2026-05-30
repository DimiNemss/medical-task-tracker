require "swagger_helper"

RSpec.describe "API::V1::Tags", type: :request do
  path "/api/v1/tags" do
    get "List tags" do
      tags "Tags"

      produces "application/json"

      response "200", "successful" do
        before do
          Tag.find_or_create_by!(
            name: "операции",
            system: true
          )
        end

        run_test!
      end
    end

    post "Create tag" do
      tags "Tags"

      consumes "application/json"
      produces "application/json"

      parameter name: :tag,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    tag: {
                      type: :object,
                      properties: {
                        name: {
                          type: :string
                        }
                      },
                      required: ["name"]
                    }
                  }
                }

      response "201", "tag created" do
        let(:tag) do
          {
            tag: {
              name: "инвентаризация"
            }
          }
        end

        run_test!
      end
    end
  end

  path "/api/v1/tags/{id}" do
    parameter name: :id,
              in: :path,
              type: :integer

    get "Show tag" do
      tags "Tags"

      produces "application/json"

      response "200", "successful" do
        let!(:tag_record) do
          Tag.create!(
            name: "custom-tag"
          )
        end

        let(:id) { tag_record.id }

        run_test!
      end
    end

    patch "Update tag" do
      tags "Tags"

      consumes "application/json"
      produces "application/json"

      parameter name: :tag,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    tag: {
                      type: :object,
                      properties: {
                        name: {
                          type: :string
                        }
                      }
                    }
                  }
                }

      response "200", "tag updated" do
        let!(:tag_record) do
          Tag.create!(
            name: "old-tag"
          )
        end

        let(:id) { tag_record.id }

        let(:tag) do
          {
            tag: {
              name: "new-tag"
            }
          }
        end

        run_test!
      end
    end

    delete "Delete tag" do
      tags "Tags"

      produces "application/json"

      response "204", "tag deleted" do
        let!(:tag_record) do
          Tag.create!(
            name: "delete-tag"
          )
        end

        let(:id) { tag_record.id }

        run_test!
      end
    end
  end
end