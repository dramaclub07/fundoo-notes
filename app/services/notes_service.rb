class NotesService
  def self.create_note(note_params, token)
    user = JwtService.decode(token)

    # Ensure user is valid
    return { success: false, error: "Invalid token" } unless user

    note = Note.new(note_params.merge(user_id: user.id))
    if note.save
      { success: true, message: "Note created successfully", note: note }
    else
      { success: false, error: note.errors.full_messages.join(", ") }
    end
  end

  def self.update_note(note_id, note_params, token)
    user = JwtService.decode(token)
    return { success: false, error: "Invalid token" } unless user && user.id

    note = Note.find_by(id: note_id, user_id: user.id)
    return { success: false, error: "Note not found" } unless note

    if note.update(note_params)
      { success: true, message: "Note updated successfully", note: note }
    else
      { success: false, error: note.errors.full_messages.join(", ") }
    end
  end

  def self.get_note_by_id(note_id, token)
    user = JwtService.decode(token)
    return { success: false, error: "Invalid token" } unless user && user.id

    note = Note.find_by(id: note_id)
    return { success: false, error: "Note not found" } unless note

    return { success: false, error: "Unauthorized access" } unless note.user_id == user.id

    { success: true, note: note }
  end

  def self.getnote(token)
    user = JwtService.decode(token)
    return { success: false, error: "Unauthorized access" } unless user && user.id

    user = User.find_by(id: user.id)
    return { success: false, error: "User not found" } unless user

    notes = user.notes.where(is_deleted: false)
    { success: true, body: notes }
  end

  def self.archive_toggle(note_id)
    note = Note.find_by(id: note_id)
    return { success: false, error: "Note not found" } unless note

    note.update(is_archived: !note.is_archived)
    { success: true, message: "Note archive status toggled", note: note }
  end

  def self.trash_toggle(note_id)
    note = Note.find_by(id: note_id)
    return { success: false, error: "Note not found" } unless note

    note.update(is_deleted: !note.is_deleted)
    { success: true, message: "Note delete status toggled", note: note }
  end
end
