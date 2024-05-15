-- cloud_providers

CREATE TABLE public.cloud_providers (
    provider_name text NOT NULL,
    provider_description text NOT NULL
);

COMMENT ON TABLE public.cloud_providers IS 'Table containing cloud providers information';
COMMENT ON COLUMN public.cloud_providers.provider_name IS 'The name of the cloud provider';
COMMENT ON COLUMN public.cloud_providers.provider_description IS 'A description of the cloud provider';

--ALTER TABLE public.cloud_providers OWNER TO <user>;

INSERT INTO public.cloud_providers (provider_name, provider_description) VALUES
    ('aws', 'Amazon Web Services'),
    ('gcp', 'Google Cloud Platform'),
    ('azure', 'Microsoft Azure'),
    ('digitalocean', 'DigitalOcean'),
    ('hetzner', 'Hetzner Cloud');

ALTER TABLE ONLY public.cloud_providers
    ADD CONSTRAINT cloud_providers_pkey PRIMARY KEY (provider_name);
