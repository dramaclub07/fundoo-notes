module Api
  module V1
    class NotesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user

      def current_user
        @current_user
      end

      def index
        notes = current_user.notes.active
        render json: { notes: notes }, status: :ok
      end

      def create
        token = request.headers["Authorization"]&.split(" ")&.last
        note_params = params.require(:note).permit(:title, :content, :color)

        result = NotesService.create_note(note_params, token)
        
        if result[:success]
          render json: result[:note], status: :created
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      def getnote
        token = request.headers["Authorization"]&.split(" ")&.last
        Rails.logger.info "Received Token: #{token}"
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
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      def trash
        note_id = params[:id]
        token = request.headers["Authorization"]&.split(" ")&.last
        result = NotesService.trash_toggle(note_id, token)
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      def archive
        note_id = params[:id]
        token = request.headers["Authorization"]&.split(" ")&.last
        result = NotesService.archive_toggle(note_id, token)
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      def update_color
        note_id = params[:id]
        color = params[:color]
        token = request.headers["Authorization"]&.split(" ")&.last
        result = NotesService.update_color(note_id, color, token)
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      private

      def note_params
        params.require(:note).permit(:title, :content, :color)
      end

      def authenticate_user
        auth_header = request.headers['Authorization']
        return render json: { error: 'Missing token' }, status: :unauthorized unless auth_header.present?

        token = auth_header.split(' ')[1]
        decoded_data = JwtService.decode(token)

        return render json: { error: 'Invalid token' }, status: :unauthorized unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

        @current_user = User.find_by(id: decoded_data["user_id"])
        return render json: { error: 'User not found' }, status: :unauthorized unless @current_user
      end
    end
  end
end