-- pgAdmin administration commands
-- Requirement	PostgreSQL command
List tables in current schema	SELECT tablename FROM pg_tables WHERE schemaname = 'public';
Current database	SELECT current_database();
Current user	SELECT current_user;
PostgreSQL version	SELECT version();
Count service requests	SELECT COUNT(*) FROM service_requests;
List database indexes	SELECT * FROM pg_indexes WHERE schemaname = 'public';
Inspect active queries	SELECT * FROM pg_stat_activity;