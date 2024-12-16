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

-- Adds shared_cpu BOOLEAN field to cloud_instances
-- ref: https://github.com/vitabaks/autobase/issues/784
ALTER TABLE ONLY public.cloud_instances
ADD COLUMN shared_cpu BOOLEAN DEFAULT FALSE;

-- Update AWS shared vCPU instances
UPDATE public.cloud_instances
SET shared_cpu = true
WHERE cloud_provider = 'aws' AND instance_name IN ('t3.small', 't3.medium');

-- Update GCP shared vCPU instances
UPDATE public.cloud_instances
SET shared_cpu = true
WHERE cloud_provider = 'gcp' AND instance_name IN ('e2-small', 'e2-medium');

-- Update Azure shared vCPU instances
UPDATE public.cloud_instances
SET shared_cpu = true
WHERE cloud_provider = 'azure' AND instance_name IN ('Standard_B1ms', 'Standard_B2s');

-- Update DigitalOcean shared vCPU instances
UPDATE public.cloud_instances
SET shared_cpu = true
WHERE cloud_provider = 'digitalocean' AND instance_name IN ('s-2vcpu-2gb', 's-2vcpu-4gb');

-- Extends 20240520144338_2.0.0_initial_scheme_setup.sql#L217 with more cloud instance types
-- Heztner price is for the region 'Geremany / Finland', other regions may vary in price.
INSERT INTO public.cloud_instances (cloud_provider, instance_group, instance_name, cpu, ram, price_hourly, price_monthly, currency, updated_at, shared_cpu) VALUES
    ('hetzner', 'Small Size', 'CX22', 2, 4, 0.0074 , 4.59, '$', '2024-12-10', true),    
    ('hetzner', 'Small Size', 'CX32', 4, 8, 0.0127 , 7.59, '$', '2024-12-10', true),
    ('hetzner', 'Medium Size', 'CX42', 8, 16, 0.0304 , 18.59, '$', '2024-12-10', true),
    ('hetzner', 'Medium Size', 'CX52', 16, 32, 0.0611 , 36.09, '$', '2024-12-10', true),
    ('hetzner', 'Small Size', 'CPX31', 4, 8, 0.025 , 15.59, '$', '2024-12-10', true),
    ('hetzner', 'Medium Size', 'CPX41', 8, 16, 0.0464 , 28.09, '$', '2024-12-10', true),
    ('hetzner', 'Medium Size', 'CPX51', 16, 32, 0.0979 , 61.09, '$', '2024-12-10', true);

-- Update all existing Hetzner instances to use USD instead of EUR for easy comparison to other IaaS Providers. 
-- Update prices and other relevant fields for Hetzner cloud instances indludes an IPv4 address
UPDATE public.cloud_instances SET price_hourly = 0.0082, price_monthly = 5.09, currency = '$', updated_at = '2024-12-10', shared_cpu = true WHERE cloud_provider = 'hetzner' AND instance_name = 'CPX11';
UPDATE public.cloud_instances SET price_hourly = 0.0138, price_monthly = 8.59, currency = '$', updated_at = '2024-12-10', shared_cpu = true WHERE cloud_provider = 'hetzner' AND instance_name = 'CPX21';
UPDATE public.cloud_instances SET price_hourly = 0.0226, price_monthly = 14.09, currency = '$', updated_at = '2024-12-10', shared_cpu = false WHERE cloud_provider = 'hetzner' AND instance_name = 'CCX13';
UPDATE public.cloud_instances SET price_hourly = 0.0435, price_monthly = 27.09, currency = '$', updated_at = '2024-12-10', shared_cpu = false WHERE cloud_provider = 'hetzner' AND instance_name = 'CCX23';
UPDATE public.cloud_instances SET price_hourly = 0.0867, price_monthly = 54.09, currency = '$', updated_at = '2024-12-10', shared_cpu = false WHERE cloud_provider = 'hetzner' AND instance_name = 'CCX33';
UPDATE public.cloud_instances SET price_hourly = 0.1725, price_monthly = 107.59, currency = '$', updated_at = '2024-12-10', shared_cpu = false WHERE cloud_provider = 'hetzner' AND instance_name = 'CCX43';
UPDATE public.cloud_instances SET price_hourly = 0.3431, price_monthly = 214.09, currency = '$', updated_at = '2024-12-10', shared_cpu = false WHERE cloud_provider = 'hetzner' AND instance_name = 'CCX53';
UPDATE public.cloud_instances SET price_hourly = 0.5138, price_monthly = 320.59, currency = '$', updated_at = '2024-12-10', shared_cpu = false WHERE cloud_provider = 'hetzner' AND instance_name = 'CCX63';

-- cloud_volumes
-- Update prices and other relevant fields for Hetzner cloud volume
UPDATE public.cloud_volumes SET price_monthly = 0.05, currency = '$', updated_at = '2024-12-10' WHERE cloud_provider = 'hetzner';

-- +goose Down
DELETE FROM public.postgres_versions WHERE major_version = 17;
