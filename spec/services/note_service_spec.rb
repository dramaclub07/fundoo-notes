require 'rails_helper'

RSpec.describe NotesService, type: :service do
  let(:user) { create(:user) }
  let(:token) { JwtService.encode({ id: user.id }) }
  let(:note) { create(:note, user: user) }

  describe '.create_note' do
    it 'creates a note successfully' do
      note_params = { title: 'New Note', content: 'This is a test note' }
      result = NotesService.create_note(note_params, token)

      expect(result[:success]).to be true
      expect(result[:note].title).to eq('New Note')
      expect(result[:note].content).to eq('This is a test note')
    end

    it 'returns an error for invalid token' do
      note_params = { title: 'Invalid Note' }
      result = NotesService.create_note(note_params, 'invalid_token')

      expect(result[:success]).to be false
      expect(result[:error]).to eq('Invalid token')
    end
  end

  describe '.update_note' do
    it 'updates a note successfully' do
      update_params = { title: 'Updated Title', content: 'Updated Content' }
      result = NotesService.update_note(note.id, update_params, token)

      expect(result[:success]).to be true
      expect(result[:note].title).to eq('Updated Title')
      expect(result[:note].content).to eq('Updated Content')
    end

    it 'returns an error for unauthorized access' do
      other_user = create(:user)
      other_token = JwtService.encode({ id: other_user.id })
      result = NotesService.update_note(note.id, { title: 'Hack' }, other_token)

      expect(result[:success]).to be false
      expect(result[:error]).to eq('Note not found')
    end
  end

  describe '.get_note_by_id' do
    it 'retrieves a note successfully' do
      result = NotesService.get_note_by_id(note.id, token)

      expect(result[:success]).to be true
      expect(result[:note].id).to eq(note.id)
    end

    it 'returns an error for unauthorized access' do
      other_user = create(:user)
      other_token = JwtService.encode({ id: other_user.id })

      result = NotesService.get_note_by_id(note.id, other_token)
      expect(result[:success]).to be false
      expect(result[:error]).to eq('Unauthorized access')
    end
  end

  describe '.getnote' do
    it 'returns notes for a valid user' do
      create_list(:note, 3, user: user)
      result = NotesService.getnote(token)

      expect(result[:success]).to be true
      expect(result[:body].size).to eq(3)
    end

    it 'returns an error for invalid token' do
      result = NotesService.getnote('invalid_token')

      expect(result[:success]).to be false
      expect(result[:error]).to eq('Unauthorized access')
    end
  end

  describe '.archive_toggle' do
    it 'toggles archive status' do
      result = NotesService.archive_toggle(note.id)

      expect(result[:success]).to be true
      expect(result[:note].is_archived).to be true

      result = NotesService.archive_toggle(note.id)
      expect(result[:note].is_archived).to be false
    end

    it 'returns an error for non-existent note' do
      result = NotesService.archive_toggle(999)

      expect(result[:success]).to be false
      expect(result[:error]).to eq('Note not found')
    end
  end

  describe '.trash_toggle' do
    it 'toggles trash status' do
      result = NotesService.trash_toggle(note.id)

      expect(result[:success]).to be true
      expect(result[:note].is_deleted).to be true

      result = NotesService.trash_toggle(note.id)
      expect(result[:note].is_deleted).to be false
    end

    it 'returns an error for non-existent note' do
      result = NotesService.trash_toggle(999)

      expect(result[:success]).to be false
      expect(result[:error]).to eq('Note not found')
    end
  end
end
