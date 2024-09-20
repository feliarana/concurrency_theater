# ConcurrencyTheater

Welcome to the ConcurrencyTheater project! This README provides instructions on setting up and running the application.

## Prerequisites

1. **Ruby Version**: Ensure you are using Ruby 3.3.0.
2. **PostgreSQL**: Have PostgreSQL installed and running.
3. **Redis**: Install and start Redis for WebSocket functionality.

## Setup Instructions

1. **Install Gems**

   Run the following command to install the required Ruby gems:

   ```bash
   bundle install
   ```
2. Generate the rails secret: `bundle exec rails secret`
3. **Configure Credentials**

Create a .env in the root of the repository. Also paste the secret from the previous step.

```bash
nano .env
```

Add the following configuration to the file:

```yaml
  DEVISE_JWT_SECRET_KEY=generated in step2
  DATABASE_USERNAME=postgres
  DATABASE_PASSWORD=2yr-DYfrvXT4Cuf9AtjMsYAPZHVWsa_R
  DATABASE_HOST=localhost
  DATABASE_PORT=5432
  DATABASE_POOL=5
```

4. **Setup Database**

Run the following command to create the database, run migrations, and seed the database with initial data:

```bash
rails db:setup
```

5. **Start the Application**

Launch the Rails server with:

```bash
rails s
```

6. **Testing with Postman**
![Setup tutorial.](https://github.com/user-attachments/assets/f24cd655-4000-4635-a52d-fd474727be8f)
   1. Import Collection, located in the folder postman.
   2. Import the Environment (localhost, also located in the folder postman.
   3. Make sure to select the localhost environment in Postman before triggering the requests.
   4. Ensure the ticket_id, user_id, and performance_id are valid based on the data in your system.

The requests will help you generate a Jwt (in the response, after you trigger the **POST /login** . Also you can list, reserve, purchase and cancel tickets. Updates should be sent via WebSockets.

**WebSocket Updates**

The application uses WebSockets to broadcast ticket updates. Ensure Redis is running to receive real-time updates.

**Troubleshooting**

- Redis Not Running: Ensure Redis is installed and running on the default port (6379).
- Database Connection Issues: Verify that PostgreSQL is running and accessible at the specified host and port.
