class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        if session[:user_id]
            render json: User.find(session[:user_id]), status: :created
        else
            not_found_response
        end
    end

    private

    def not_found_response
        render json: {error: "Not authorised"}, status: :unauthorized
    end

    def invalid_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end
end
