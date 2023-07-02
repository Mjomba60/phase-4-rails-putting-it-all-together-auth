class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_response
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    before_action :authorize

    def index
        render json: Recipe.all, include: ['user'], status: :created
    end

    def create
        recipe = User.find(session[:user_id]).recipes.create!(recipe_params)
        render json: recipe, include: ['user'], status: :created
    end



    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def authorize
        return render json: {errors: ["Not authorized"]}, status: 
        :unauthorized unless session.include? :user_id
    end

    def invalid_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def not_found_response(error)
        render json: {error: error}, status: :not_found
    end
end
