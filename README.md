# nginx-next-sqldb-dock
A Docker template for a multi-container setup featuring a Next.js app proxied by NGINX, with an optional SQLite3 database container for persistence and file serving capabilities.

## Overview
This template provides a scalable foundation combining a Next.js frontend, NGINX reverse proxy, and the SQLite3 database. The file server feature can be enabled to serve static files, making it ideal for managing offline content.

## Structure
- `next-app/` - Your Next.js app lives here (using the App Router).
- `nginx/` - NGINX configuration, acting as the reverse proxy and optional file server.
- `sqldb/` - Directory for SQLite3-related files:
  - `sqldb/data/` - Stores the SQLite database file (`noxsvault.db`).
  - `sqldb/scripts/` - Contains SQL initialization scripts (e.g., `init.sql`).
- `Dockerfile.next` - Builds the Next.js app container.
- `Dockerfile.nginx` - Sets up the NGINX container.
- `Dockerfile.sqldb` - Builds the SQLite3 database container.
- `docker-compose.yml` - Orchestrates the Next.js, NGINX, and SQLite3 containers.

## Usage
1. **Set Up Your Next.js App**:
- Place your Next.js app in the `next-app/` directory. If you don’t have one, create it:
    ```bash
     npx create-next-app@latest next-app --ts --app
    ```
- Ensure your app uses the App Router (e.g., app/ directory structure).

2. **Prepare the File Server (Optional):**
- Create a directory for static files (e.g., </home/pi/resources> on Raspberry Pi).
- Add test files (e.g., `echo "Hello, NOXSVAULT!" > /home/pi/resources/test.txt`).

3. **Build and Run:**
From the root directory, run:
```bash
docker-compose up --build
```
- Access the app at `http://localhost:3000` (Next.js) or `http://localhost` (NGINX proxy).

4. **Enable the File Server (Optional):**
- Uncomment the `location /files/` block in `nginx/nginx.conf`.
- Uncomment and adjust the `volumes` mapping in `docker-compose.yml` (e.g., `/home/pi/resources:/resources`).
- Rebuild with `docker-compose up --build`.
- Access files at `http://localhost/files/`.

5. **Initialize the Database:**
- The `sqldb` container runs the `init.sql` script to create the `users` and `files` tables with an initial admin user. 
- Test the database endpoint at `http://localhost:3000/api/test-db`.

## Configuration
- **NGINX (Port 80)**: Proxies requests to the Next.js app (port 3000) by default. Enable the file server by uncommenting the `/files/` location block.
- **Next.js (Port 3000)**: Hosts the API and frontend. Customize API routes in `next-app/app/api/`.
- **SQLite3**: Stores data in `sqldb/data/noxsvault.db`. Modify `sqldb/scripts/init.sql` to change the schema.

## Example Endpoints
- Test Database: `http://localhost:3000/api/test-db` (returns users table).
- Create User: `http://localhost:3000/api/users` (POST with JSON `{ "username": "user", "password": "pass", "role": "guest" }`).

## Notes
- **Architecture**: Optimized for ARM64. Ensure native dependencies (e.g., `better-sqlite3`, `bcrypt`) are rebuilt during the build process.
- **Customization**: Adjust `nginx/nginx.conf` or d`ocker-compose.yml` for specific needs (e.g., ports, paths).
- **Troubleshooting**: Check logs with `docker-compose logs <service>` (e.g., `nginx`, `next-app`, `sqldb`). Common issues include network errors or missing files.
- **Offline Usage**: Pre-pull required images (e.g., `nginx:alpine`, `node:18-alpine`) if running without internet.