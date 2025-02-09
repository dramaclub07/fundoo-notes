class CreateUsers < ActiveRecord::Migration[8.0]
  def change  
    create_table :users do |t|  
      t.string :name  
      t.string :email  
      t.string :password  # Use password_digest for `has_secure_password`  in database
      t.string :phone_number  
      t.timestamps  
    end  
    add_index :users, :email, unique: true  
    add_index :users, :phone_number, unique: true  
  end  
end