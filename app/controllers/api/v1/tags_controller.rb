module Api
  module V1
    class TagsController < BaseController
      def index
        tags = Tag.order(:name)

        render_success(
          TagBlueprint.render_as_hash(tags)
        )
      end
    end
  end
end