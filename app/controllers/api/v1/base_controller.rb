module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def handle_record_invalid(exception)
        render json: { errors: exception.record.errors }, status: 422
      end

      def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore

        error_message = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
        render json: { errors: error_message }, status: 401
      end
    end
  end
end
