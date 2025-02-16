**📝 Fundoo Notes - Rails Application {Built Differently}**

*Fundoo Notes is a robust and feature-rich note-taking application built with Ruby on Rails and PostgreSQL. It offers seamless user management, note operations, and integrates advanced tools like Swagger and RabbitMQ for a modern developer experience.*

📌 Key Features:

✅ User Authentication: Secure registration and login using JWT

🗒️ Note Management: Perform CRUD operations on notes

📊 API Documentation: Integrated Swagger for interactive API exploration

🐇 Asynchronous Jobs: RabbitMQ for handling background tasks

🧪 Comprehensive Testing: RSpec for unit, service, and integration testing

🧪 RSpec Coverage:

Models:

User

Note

Services:

UserService

NotesService

Requests:

UserRegistration

UserLogin

NoteCreation

NoteDeletion

Factories:

Consistent test data generation for seamless testing

🚀 Setup Instructions:

Clone the repository:

git clone https://github.com/dramaclub07/fundoo-notes.git
cd fundoo-notes

Install dependencies:

bundle install

Set up the database:

rails db:create db:migrate db:seed

Run the Rails server:

rails server

Execute tests using RSpec:

rspec

📚 *Contribution Guidelines:*

Create feature branches for new changes.

Ensure RSpec tests cover your changes.

Submit pull requests with detailed descriptions.
  eg**- git commit -m "[Name]ADD: Added feature to create notes with tags"*

👨‍💻 Contributors:

**Priyanshu** - Core Developer

Happy Coding! 💻

