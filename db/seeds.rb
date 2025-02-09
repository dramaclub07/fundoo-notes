# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:


# # Create Users
# user1 = User.create!(name: "Alice", email: "alice@example.com", password: "password")
# user2 = User.create!(name: "Bob", email: "bob@example.com", password: "password")

# # Create Notes
# note1 = user1.notes.create!(title: "First Note", content: "This is a test note.")

# # Create Collaboration
# Collaboration.create!(user: user2, note: note1)



#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
# #   end
# User.create([  
#   { name: 'Darun Singh', email: 'sdaru91@gmail.com', password: 'Qwety87' },  
#   { name: 'Semantic Singh', email: 'semantic@gmail.com', password: 'Qwety87' },  
#   { name: 'Jemantic Singh', email: 'semantic101@gmail.com', password: 'Qwety87' },  
#   { name: 'Varun Kanojia', email: 'VarunKanojia@gmail.com', password: 'Qwerty@ty07' },  
#   { name: 'Vishal Kanojia', email: 'VishalKanojia@gmail.com', password: 'Qwerty@ty07' },  
#   { name: 'Aryan Negi', email: 'AryanNegi@gmail.com', password: 'Aryan@ty07' },  
#   { name: 'Rajnath Singh', email: 'rajnat@gmail.com', password: 'Password' },  
# ])

