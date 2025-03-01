class NotesService
  def self.create_note(note_params, token)
    decoded_data = JwtService.decode(token)
    
    # Ensure decoded_data is valid and contains user_id
    return { success: false, error: "Invalid token data" } unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

    user = User.find_by(id: decoded_data["user_id"])
    return { success: false, error: "User not found" } unless user

    # Convert ActionController::Parameters to Hash
    note_params = note_params.to_h if note_params.is_a?(ActionController::Parameters)

    note = user.notes.build(note_params)  # Ensures the note is associated with the user
    if note.save
      { success: true, message: "Note created successfully", note: note }
    else
      Rails.logger.error "Validation errors: #{note.errors.full_messages.join(", ")}"
      { success: false, error: note.errors.full_messages.join(", ") }
    end
  end

  def self.update(note_id, token, note_params)
    decoded_data = JwtService.decode(token)
    return { success: false, error: "Invalid token data" } unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

    user = User.find_by(id: decoded_data["user_id"])
    return { success: false, error: "User not found" } unless user

    note = Note.find_by(id: note_id, user_id: user.id)
    return { success: false, error: "Note not found" } unless note

    if note.update(note_params)
      { success: true, message: "Note updated successfully", note: note }
    else
      { success: false, error: note.errors.full_messages.join(", ") }
    end
  end


  def self.update_color(note_id, token, note_params)
    decoded_data = JwtService.decode(token)
    return { success: false, error: "Invalid token data" } unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

    user = User.find_by(id: decoded_data["user_id"])
    return { success: false, error: "User not found" } unless user

    note = Note.find_by(id: note_id, user_id: user.id)
    return { success: false, error: "Note not found" } unless note

    if note.update(note_params)
      { success: true, message: "Note updated successfully", note: note }
    else
      { success: false, error: note.errors.full_messages.join(", ") }
    end
  end

  def self.get_note_by_id(note_id, token)
    decoded_data = JwtService.decode(token)
    return { success: false, error: "Invalid token data" } unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

    user = User.find_by(id: decoded_data["user_id"])
    return { success: false, error: "User not found" } unless user

    note = Note.find_by(id: note_id)
    return { success: false, error: "Note not found" } unless note
    return { success: false, error: "Unauthorized access" } unless note.user_id == user.id

    { success: true, note: note }
  end

  def self.getnote(token)
    decoded_data = JwtService.decode(token)
    return { success: false, error: "Invalid token data" } unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

    user = User.find_by(id: decoded_data["user_id"])
    return { success: false, error: "User not found" } unless user

    notes = user.notes.where(is_deleted: false)
    { success: true, body: notes }
  end

  def self.archive_toggle(note_id, token)
    decoded_data = JwtService.decode(token)
    return { success: false, error: "Invalid token data" } unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

    user = User.find_by(id: decoded_data["user_id"])
    return { success: false, error: "User not found" } unless user

    note = Note.find_by(id: note_id, user_id: user.id)
    return { success: false, error: "Note not found" } unless note

    note.update(is_archived: !note.is_archived)
    { success: true, message: "Note archive status toggled", note: note }
  end

  def self.trash_toggle(note_id, token)
    decoded_data = JwtService.decode(token)
    return { success: false, error: "Invalid token data" } unless decoded_data.is_a?(Hash) && decoded_data["user_id"].present?

    user = User.find_by(id: decoded_data["user_id"])
    return { success: false, error: "User not found" } unless user

    note = Note.find_by(id: note_id, user_id: user.id)
    return { success: false, error: "Note not found" } unless note

    note.update(is_deleted: !note.is_deleted)
    { success: true, message: "Note delete status toggled", note: note }
  end
end