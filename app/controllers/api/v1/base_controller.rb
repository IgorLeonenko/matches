module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

      private

      def handle_record_invalid(exception)
        render json: { errors: exception.record.errors }, status: 422
      end
    end
  end
end
