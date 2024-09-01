# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF")
Book.destroy_all
Author.destroy_all
ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")

author1 = Author.create(first_name: "JS", last_name: "Author", age: 25)
author2 = Author.create(first_name: "Golang", last_name: "Author", age: 12)
author3 = Author.create(first_name: "Dart", last_name: "Author", age: 8)
author4 = Author.create(first_name: "PHP", last_name: "Author", age: 37)

book1 = Book.create(title: "JavaScript", author: author1)
book2 = Book.create(title: "Golang", author: author2)
book3 = Book.create(title: "Dart", author: author3)
book4 = Book.create(title: "PHP", author: author4)

puts "Seeded #{Book.count} Books and #{Author.count} Authors"
