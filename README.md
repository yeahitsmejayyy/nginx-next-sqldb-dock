# Docker Template: Nginx + Next.js + SQLite

A Docker template for a multi-container setup featuring a Next.js app proxied by NGINX, with an optional SQLite3 database container for persistence and file serving capabilities.

## Overview
This template provides a scalable foundation combining:
- **Next.js** (App Router) for frontend and API handling.
- **NGINX** for reverse proxy and optional file serving.
- **SQLite3** for persistence (optional).

## Structure
```
├── next-app/          # Place your Next.js app here
├── nginx/             # NGINX configuration (reverse proxy, optional file server)
│   ├── nginx.conf
├── sqldb/             # SQLite3 database setup
│   ├── data/          # SQLite database storage (`app.db`)
│   ├── scripts/
│   │   ├── init.sql  # DB schema & test data
├── Dockerfile.next    # Next.js app container
├── Dockerfile.nginx   # NGINX container
├── Dockerfile.sqldb   # SQLite3 container
├── docker-compose.yml # Service orchestration
└── README.md
```

## Usage
### 1. Set Up Your Next.js App
Place your Next.js project in the `next-app/` directory. If you don’t have one, create it:
```sh
npx create-next-app@latest next-app --ts --app
```
Ensure it builds successfully before proceeding.

### 2. (Optional) Enable File Server
To serve static files:
- Create a directory (e.g., `/home/user/resources`).
- Add test files: `echo "Hello, Docker!" > /home/user/resources/test.txt`.
- Uncomment `/files/` block in `nginx.conf` and adjust `volumes` in `docker-compose.yml`.

### 3. Build and Run
```sh
docker-compose up --build
```
- Access Next.js app: [http://localhost:3000](http://localhost:3000)
- Access via NGINX: [http://localhost](http://localhost)

### 4. Initialize the Database
The `sqldb` container runs `init.sql` to create `users` and `files` tables.
- Test database: [http://localhost:3000/api/test-db](http://localhost:3000/api/test-db)

## Configuration
- **NGINX (Port 80)**: Reverse proxy to Next.js (port 3000). Enable file serving if needed.
- **Next.js (Port 3000)**: Customize API routes in `next-app/app/api/`.
- **SQLite3**: Data stored in `sqldb/data/app.db`. Modify `init.sql` for schema changes.

## Example API Endpoints
- Test Database: `http://localhost:3000/api/test-db`
- Create User:
```sh
POST http://localhost:3000/api/users
{
  "username": "user",
  "password": "pass",
  "role": "guest"
}
```

## Notes
- **Ensure Next.js app builds successfully before running containers.**
- **Check logs with** `docker-compose logs <service>` (e.g., `nginx`, `next-app`, `sqldb`).
- **For offline usage**, pre-pull images (`nginx:alpine`, `node:18-alpine`).

Now you're ready to go!