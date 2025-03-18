-- Initialize NOXSVAULT database
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,  -- Store hashed passwords
  role TEXT NOT NULL CHECK(role IN ('admin', 'guest'))
);

CREATE TABLE files (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  path TEXT NOT NULL,  -- e.g., '/resources/file1.txt'
  category TEXT,       -- e.g., 'docs', 'media'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_category ON files(category);

-- Initial admin user (replace 'admin_password' with a hashed password)
INSERT INTO users (username, password, role) VALUES ('admin', 'hashed_admin_password_here', 'admin');