module Api
  module V1
    class TaskTagsController < BaseController
      def create
        task = Task.find(params[:task_id])
        tag = Tag.find(params[:tag_id])

        task.tags << tag unless task.tags.include?(tag)

        render_success(
          TaskBlueprint.render_as_hash(task.reload)
        )
      end

      def destroy
        task = Task.find(params[:task_id])
        tag = Tag.find(params[:tag_id])

        task.tags.destroy(tag)

        render_success(
          TaskBlueprint.render_as_hash(task.reload)
        )
      end
    end
  end
end