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
2.  **Configure Credentials**

  Set up your credentials for the development environment. Open the credentials file with:
  ```bash
  EDITOR="code --wait" rails credentials:edit
  ```

  Add the following configuration to the file:
  ```yaml
  development:
    database_username: postgres
    database_password: postgres
    database_host: localhost
    database_port: 5432
    database_pool: 5
  ```

3.  **Setup Database**

  Run the following command to create the database, run migrations, and seed the database with initial data:
   ```bash
   rails db:setup
   ```


4.  **Start the Application**

Launch the Rails server with:
   ```bash
   rails s
   ```


5.  **Testing with Postman**

You can test the ticket reservation feature using Postman or cURL. To reserve a ticket, send a POST request to:
   ```bash
   curl --location --request POST 'localhost:3000/tickets' \
        --header 'Content-Type: application/json' \
        --data-raw '{"status": "reserved", "user_id": 1, "performance_id": 1, "price": 55}'
   ```
Ensure the ticket_id, user_id, and performance_id are valid based on the data in your system. 

The request will reserve a ticket and broadcast updates via WebSockets.


**WebSocket Updates**

The application uses WebSockets to broadcast ticket updates. Ensure Redis is running to receive real-time updates.

**Troubleshooting**
- Redis Not Running: Ensure Redis is installed and running on the default port (6379).

- Database Connection Issues: Verify that PostgreSQL is running and accessible at the specified host and port.
