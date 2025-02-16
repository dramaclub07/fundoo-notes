require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { create(:user)}
  let(:note) { create(:note, user: user) }
  let(:active_note) { create(:note, user: user, is_deleted: false, is_archived: false) }
  let(:archived_note) { create(:note, user: user, is_deleted: false, is_archived: true) }
  let(:deleted_note) { create(:note, user: user, is_deleted: true, is_archived: false) }

  describe "Associations" do
    it { is_expected.to belong_to(:user) }
    it { should have_many(:collaborations) }
    it { should have_many(:collaborators).through(:collaborations) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe "Scopes" do
    before do
      @active_note = create(:note, user: user, is_deleted: false, is_archived: false)
      @archived_note = create(:note, user: user, is_archived: true)
      @deleted_note = create(:note, user: user, is_deleted: true)
    end

    it "returns active notes" do
      expect(Note.active).to include(active_note)
      expect(Note.active).not_to include(archived_note, deleted_note)
    end

    it "returns archived notes" do
      expect(Note.archived).to include(archived_note)
      expect(Note.archived).not_to include(active_note, deleted_note)
    end

    it "returns deleted notes" do
      expect(Note.deleted).to include(deleted_note)
      expect(Note.deleted).not_to include(active_note, archived_note)
    end
  end
end
