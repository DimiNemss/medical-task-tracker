Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      get "health", to: "health#index"

      resources :tags, only: %i[
        index
        create
        update
        destroy
      ]
      resources :tasks do
        resources :tags,
                  only: [:create],
                  controller: "task_tags" do
          delete ":tag_id",
                action: :destroy,
                on: :collection
        end

      patch "occurrences/:occurrence_date",
            to: "task_occurrences#update",
            as: :occurrence
      end
    end
  end
end