# app/controllers/api/v1/notes_controller.rb
module Api
  module V1
    class NotesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        notes = current_user.notes.active 
        render json: { notes: notes }, status: :ok
      end

      def create
        token = request.headers["Authorization"]&.split(" ")&.last
        result = NotesService.create_note(token, note_params)
        if result[:success]
          render json: result[:note], status: :created
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      
      def note_params
        params.require(:note).permit(:title, :content, :color)
      end
    end
  end
end
