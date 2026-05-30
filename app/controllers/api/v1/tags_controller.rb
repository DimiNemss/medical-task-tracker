module Api
  module V1
    class TagsController < BaseController
      def index
        render_success(
          TagBlueprint.render_as_hash(Tag.order(:name))
        )
      end

      def show
        render_success(
          TagBlueprint.render_as_hash(find_tag)
        )
      end

      def create
        tag = Tag.new(tag_params)

        if tag.save
          render_success(
            TagBlueprint.render_as_hash(tag),
            status: :created
          )
        else
          render_error(
            tag.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def update
        tag = find_tag

        if tag.update(tag_params)
          render_success(
            TagBlueprint.render_as_hash(tag)
          )
        else
          render_error(
            tag.errors.full_messages,
            status: :unprocessable_entity
          )
        end
      end

      def destroy
        tag = find_tag

        if tag.destroy && tag.destroyed?
          head :no_content
        else
          render_error(
            tag.errors.full_messages,
            status: :forbidden
          )
        end
      end

      private

      def find_tag
        Tag.find(params[:id])
      end

      def tag_params
        params.require(:tag).permit(:name)
      end

      def system_tag_error
        render_error(
          ["System tags cannot be modified"],
          status: :forbidden
        )
      end
    end
  end
end