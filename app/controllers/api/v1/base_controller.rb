module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      rescue_from ActiveRecord::RecordInvalid, with: :handle_errors

      private

      def handle_errors(exception)
        render json: { errors: exception.record.errors }, status: 422
      end
    end
  end
end
