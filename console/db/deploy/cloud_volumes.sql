-- cloud_volumes

CREATE TABLE public.cloud_volumes (
    cloud_provider text NOT NULL,
    volume_type text NOT NULL,
    volume_description text NOT NULL,
    volume_min_size integer NOT NULL,
    volume_max_size integer NOT NULL,
    price_monthly numeric NOT NULL,
    currency CHAR(1) DEFAULT '$' NOT NULL,
    updated_at date DEFAULT CURRENT_DATE
);

-- ALTER TABLE public.cloud_volumes OWNER TO <user>;

COMMENT ON TABLE public.cloud_volumes IS 'Table containing cloud volume information for various cloud providers';
COMMENT ON COLUMN public.cloud_volumes.cloud_provider IS 'The name of the cloud provider';
COMMENT ON COLUMN public.cloud_volumes.volume_type IS 'The type of the volume (the name provided by the API)';
COMMENT ON COLUMN public.cloud_volumes.volume_description IS 'Description of the volume';
COMMENT ON COLUMN public.cloud_volumes.volume_min_size IS 'The minimum size of the volume (in GB)';
COMMENT ON COLUMN public.cloud_volumes.volume_max_size IS 'The maximum size of the volume (in GB)';
COMMENT ON COLUMN public.cloud_volumes.price_monthly IS 'The monthly price per GB of the volume';
COMMENT ON COLUMN public.cloud_volumes.currency IS 'The currency of the price (default: $)';
COMMENT ON COLUMN public.cloud_volumes.updated_at IS 'The date when the volume information was last updated';

-- The price is approximate because it is specified for one region and may differ in other regions.
-- aws, gcp, azure: the price is for the region 'US East'
INSERT INTO public.cloud_volumes (cloud_provider, volume_type, volume_description, volume_min_size, volume_max_size, price_monthly, currency, updated_at) VALUES
    ('aws', 'st1', 'Throughput Optimized HDD Disk (Max throughput: 500 MiB/s, Max IOPS: 500)', 125, 16000, 0.045, '$', '2024-05-15'),
    ('aws', 'gp3', 'General Purpose SSD Disk (Max throughput: 1,000 MiB/s, Max IOPS: 16,000)', 10, 16000, 0.080, '$', '2024-05-15'),
    ('aws', 'io2', 'Provisioned IOPS SSD Disk (Max throughput: 4,000 MiB/s, Max IOPS: 256,000)', 10, 64000, 0.125, '$', '2024-05-15'),
    ('gcp', 'pd-standard', 'Standard Persistent HDD Disk (Max throughput: 180 MiB/s, Max IOPS: 3,000)', 10, 64000, 0.040, '$', '2024-05-15'),
    ('gcp', 'pd-balanced', 'Balanced Persistent SSD Disk (Max throughput: 240 MiB/s, Max IOPS: 15,000)', 10, 64000, 0.100, '$', '2024-05-15'),
    ('gcp', 'pd-ssd', 'SSD Persistent Disk (Max throughput: 1,200 MiB/s, Max IOPS: 100,000)', 10, 64000, 0.170, '$', '2024-05-15'),
    ('gcp', 'pd-extreme', 'Extreme Persistent SSD Disk (Max throughput: 2,400 MiB/s, Max IOPS: 120,000)', 500, 64000, 0.125, '$', '2024-05-15'),
    ('azure', 'Standard_LRS', 'Standard HDD (Max throughput: 500 MiB/s, Max IOPS: 2,000)', 10, 32000, 0.040, '$', '2024-05-15'),
    ('azure', 'StandardSSD_LRS', 'Standard SSD (Max throughput: 750 MiB/s, Max IOPS: 6,000)', 10, 32000, 0.075, '$', '2024-05-15'),
    ('azure', 'Premium_LRS', 'Premium SSD (Max throughput: 900 MiB/s, Max IOPS: 20,000)', 10, 32000, 0.132, '$', '2024-05-15'),
    ('azure', 'UltraSSD_LRS', 'Ultra SSD (Max throughput: 10,000 MiB/s, Max IOPS: 400,000)', 10, 64000, 0.120, '$', '2024-05-15'),
    ('digitalocean', 'ssd', 'SSD Block Storage (Max throughput: 300 MiB/s, Max IOPS: 7,500)', 10, 16000, 0.100, '$', '2024-05-15'),
    ('hetzner', 'ssd', 'SSD Block Storage (Max throughput: N/A MiB/s, Max IOPS: N/A)', 10, 10000, 0.052, '€', '2024-05-15');

ALTER TABLE ONLY public.cloud_volumes
    ADD CONSTRAINT cloud_volumes_pkey PRIMARY KEY (cloud_provider, volume_type);

ALTER TABLE ONLY public.cloud_volumes
    ADD CONSTRAINT cloud_volumes_cloud_provider_fkey FOREIGN KEY (cloud_provider) REFERENCES public.cloud_providers(provider_name);
