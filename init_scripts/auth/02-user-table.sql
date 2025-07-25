CREATE TABLE users (
    id TEXT PRIMARY KEY DEFAULT ksuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_user_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();  

-- Create index on email for faster lookups
CREATE INDEX idx_users_email ON users(email);

-- Create a unique index on email to enforce uniqueness
CREATE UNIQUE INDEX idx_users_email_unique ON users(email); 

INSERT INTO users (email, password_hash)
VALUES ('admin@example.com', '$2b$12$KIX/8Z8Z8Z8Z8Z8Z8Z8Z8u');