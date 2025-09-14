-- Database initialization script for AGSA Government Agent AI
-- This script runs when the PostgreSQL container starts for the first time

-- Create extensions if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Set timezone
SET timezone = 'UTC';

-- Create indexes for better performance (Django will create the tables)
-- These will be applied after Django migrations run

-- Note: Tables will be created by Django migrations
-- This script is mainly for database-level configurations