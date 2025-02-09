class SetDefault < ActiveRecord::Migration[8.0]
  def change
    change_column_default :notes, :is_archived, false
    change_column_default :notes, :is_deleted, false
  end
end
