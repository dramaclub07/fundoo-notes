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
          render json: { error: result[:errors] }, status: :unprocessable_entity
        end
      end

      def getnote
        token = request.headers["Authorization"]&.split(" ")&.last
        result = NotesService.getnote(token)
        if result[:success]
          render json: { notes: result[:body] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      def getnotebyid
        token = request.headers["Authorization"]&.split(" ")&.last
        if token.nil?
          render json: { error: 'Missing authorization token' }, status: :unauthorized
          return
        end
        
        note_id = params[:id]
        result = NotesService.get_note_by_id(note_id, token)

        if result[:success]
          render json: result[:note], status: :ok
        else
          case result[:error]
          when "invalid token", "Unauthorized access"
            render json: { error: result[:error] }, status: :unauthorized
          when "note not found"
            render json: { error: result[:error] }, status: :not_found
          else
            render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end
    end

      def update
        note_id = params[:id]
        token = request.headers["Authorization"]&.split(" ")&.last
        result = NotesService.update_note(note_id, token, note_params)
        if result[:success]
          render json: result[:note], status: :ok
        else
          render json: { error: result[:errors] }, status: :unprocessable_entity
        end
      end

      def trash
        note_id = params[:id]
        result = NotesService.trash_toggle(note_id)
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      def archive
        note_id = params[:id]
        result = NotesService.archive_toggle(note_id)
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { error: result[:errors] }, status: :unprocessable_entity
        end
      end

      def update_color
        note_id = params[:id]
        color = params[:color]
        result = NotesService.update_color(note_id, color)
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { error: result[:errors] }, status: :unprocessable_entity
        end
      end

      private

      def note_params
        params.require(:note).permit(:title, :content, :color)
      end
    end
  end
end
