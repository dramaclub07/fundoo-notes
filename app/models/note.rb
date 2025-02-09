# app/models/note.rb
class Note < ApplicationRecord
  belongs_to :user
  has_many :collaborations
  has_many :collaborators, through: :collaborations, source: :user

  validates :title, presence: true
  validates :content, presence: true

  scope :active, -> { where(is_deleted: false, is_archived: false) }
  scope :archived, -> { where(is_archived: true) }
  scope :deleted, -> { where(is_deleted: true) }
end