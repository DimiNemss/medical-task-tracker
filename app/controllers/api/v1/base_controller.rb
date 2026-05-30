module Api
  module V1
    class BaseController < ApplicationController
      include Pagy::Backend

      rescue_from ActiveRecord::RecordNotFound,
                   with: :render_not_found

      rescue_from Pagy::OverflowError,
             with: :render_page_not_found

      private

      def render_success(data = {}, status: :ok)
        render json: data, status: status
      end

      def render_error(message, status: :unprocessable_entity)
        render json: { error: message }, status: status
      end

      def render_not_found(error)
        render_error(error.message, status: :not_found)
      end
      
      def render_page_not_found(_error)
        render_error(
          "Page not found",
          status: :not_found
        )
      end      
    end
  end
end