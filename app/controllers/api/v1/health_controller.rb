module Api
  module V1
    class HealthController < BaseController
      def index
        render_success(
          {
            status: "ok"
          }
        )
      end
    end
  end
end