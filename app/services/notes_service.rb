class NotesService
  def self.create_note(token, note_params)
    user = JwtService.decode(token)
    note = user.notes.new(note_params)
    if note.save
      { success: true, note: note }
    else
      { success: false, errors: note.errors.full_messages }
    end
  end

  def self.update_note(note_id, token, note_params)
    user_id = JwtService.decode(token)
    note = Note.find_by(id: note_id)
    if note && note.user_id == user_id[:id]
      note.update(title: note_params[:title], content: note_params[:content])
      { success: true, note: note }
    else
      { success: false, errors: "Unauthorized access" }
    end
  end

  def self.getnote(token) #use redis caching for get and
    user_id = JwtService.decode(token)
    return { success: false, error: "Unauthorized access" } unless user_id

    user = User.find_by(id: user_id[:id])
    return { success: false, error: "User not found" } unless user

    notes = user.notes.where(is_deleted: false).includes(:user)
    return { success: false, error: "Could not get notes" } if notes.empty?

    { success: true, body: notes }
  end

  def self.get_note_by_id(note_id, token)
    user_id = JwtService.decode(token)
    note = Note.find_by(id: note_id)
    if note && note.user_id == user_id[:id]
      { success: true, note: note }
    else
      { success: false, error: "Token not valid for this model" }
    end
  end

  def self.archive_toggle(note_id)
    note = Note.find_by(id: note_id)
    return { success: false, error: "Note not found" } unless note

    note.update(is_archived: !note.is_archived)
    { success: true, message: 'Note archive status toggled' }
  end

  def self.trash_toggle(note_id)
    note = Note.find_by(id: note_id)
    if note
      if note.is_deleted == false
        note.update(is_deleted: true)
      else
        note.update(is_deleted: false)
      end
      {success: true, message: 'Note deleted status toggled'}
    else
      { success: false, error: "Note not found" }
    end
  end

  def self.update_color(note_id, color)
    note = Note.find_by(id: note_id)
    if note
      note.update(color: color)
      { success: true, message: "Color updated to #{color}" }
    else
      { success: false, errors: "Note not found" }
    end
  end

  # def self.add_collaborator(note, email)
  #   collaborator = User.find_by(email: email)
  #   if collaborator
  #     note.collaborations.create(user: collaborator)
  #     { success: true, message: 'Collaborator added' }
  #   else
  #     { success: false, error: 'User not found' }
  #   end
  # end

  # def self.delete_note(note_id, token)
  #   user_id = JwtService.decode(token)
  #   note = Note.find_by(id: note_id)
  #   return { success: false, error: "Note not found" } unless note

  #   if note.user_id == user_id[:id]
  #     note.update(is_deleted: !note.is_deleted)
  #     { success: true, message: 'Note moved to bin' }
  #   else
  #     { success: false, error: "Unauthorized access" }
  #   end
  # end

  # def self.trash_note(user, note_id)
  #   note = user.notes.find_by(id: note_id)
  #   return { success: false, error: "Note not found" } unless note

  #   note.update(trashed: !note.trashed)
  #   {
  #     success: true,
  #     message: "Note trash status updated",
  #     note: note.as_json(only: [:id, :title, :content, :archived, :trashed, :color, :created_at, :updated_at])
  #   }
  # end


end
