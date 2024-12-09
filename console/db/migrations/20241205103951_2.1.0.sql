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


-- Extends 20240520144338_2.0.0_initial_scheme_setup.sql#L217 with more cloud instance types
-- The price is approximate because it is specified for one region and may differ in other regions.
-- aws, gcp, azure: the price is for the region 'US East'
INSERT INTO public.cloud_instances (cloud_provider, instance_group, instance_name, cpu, ram, price_hourly, price_monthly, currency, updated_at) VALUES
    ('hetzner', 'Small Size', 'CX22', 2, 4, 0.0064 , 3.99, '$', '2024-12-10'),    
    ('hetzner', 'Small Size', 'CX32', 4, 8, 0.0117 , 6.99, '$', '2024-12-10'),
    ('hetzner', 'Medium Size', 'CX42', 8, 16, 0.0294 , 17.99, '$', '2024-12-10'),
    ('hetzner', 'Medium Size', 'CX52', 16, 32, 0.0601 , 35.49, '$', '2024-12-10');
    
