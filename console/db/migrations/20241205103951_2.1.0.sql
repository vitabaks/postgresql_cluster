-- +goose Up

-- Postgres versions
INSERT INTO public.postgres_versions (major_version, release_date, end_of_life) 
VALUES (17, '2024-09-26', '2029-11-08');

-- Extensions
UPDATE public.extensions
SET postgres_max_version = '17'
WHERE extension_name IN (
    'pgaudit',
    'pg_cron',
    'pg_partman',
    'pg_repack',
    'pg_stat_kcache',
    'pg_wait_sampling',
    'pgvector',
    'postgis',
    'pgrouting',
    'timescaledb'
);

-- +goose Down
DELETE FROM public.postgres_versions 
WHERE major_version = 17;
