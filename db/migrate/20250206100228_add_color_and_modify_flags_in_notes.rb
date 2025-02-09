class AddColorAndModifyFlagsInNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :notes, :color, :string, default: "white" # Adding color field
    change_column :notes, :is_archived, :boolean, default: false
    change_column :notes, :is_deleted, :boolean, default: false
  end
end
