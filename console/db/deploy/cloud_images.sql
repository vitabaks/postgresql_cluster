-- cloud_images

CREATE TABLE public.cloud_images (
    cloud_provider text NOT NULL,
    region text NOT NULL,
    image jsonb NOT NULL,
    arch text DEFAULT 'amd64' NOT NULL,
    os_name text NOT NULL,
    os_version text NOT NULL,
    updated_at date DEFAULT CURRENT_DATE
);

COMMENT ON TABLE public.cloud_images IS 'Table containing cloud images information for various cloud providers';
COMMENT ON COLUMN public.cloud_images.cloud_provider IS 'The name of the cloud provider';
COMMENT ON COLUMN public.cloud_images.region IS 'The region where the image is available';
COMMENT ON COLUMN public.cloud_images.image IS 'The image details in JSON format';
COMMENT ON COLUMN public.cloud_images.arch IS 'The architecture of the operating system (default: amd64)';
COMMENT ON COLUMN public.cloud_images.os_name IS 'The name of the operating system';
COMMENT ON COLUMN public.cloud_images.os_version IS 'The version of the operating system';
COMMENT ON COLUMN public.cloud_images.updated_at IS 'The date when the image information was last updated';

--ALTER TABLE public.cloud_images OWNER TO <user>;

-- For all cloud providers except AWS, the image is the same for all regions.
-- For AWS, the image must be specified for each specific region.
INSERT INTO public.cloud_images (cloud_provider, region, image, arch, os_name, os_version, updated_at) VALUES
    ('aws', 'af-south-1', '{"image_id": "ami-078b3985bbc361448"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-east-1', '{"image_id": "ami-09527147898b28c8f"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-south-1', '{"image_id": "ami-0d82b4dd52aa37cc3"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-south-2', '{"image_id": "ami-0abf88d7671119127"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-southeast-3', '{"image_id": "ami-0fb840c267c9798a4"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-southeast-4', '{"image_id": "ami-0de41b55a37aa24b6"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-northeast-1', '{"image_id": "ami-047b270f7afae25a9"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-northeast-2', '{"image_id": "ami-00dade17b7cbec931"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-northeast-3', '{"image_id": "ami-06d946d6e0d7e0a3b"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-southeast-1', '{"image_id": "ami-0b1d56f717447bdcf"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ap-southeast-2', '{"image_id": "ami-015c2e3917f29eec9"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-central-1', '{"image_id": "ami-0c027353d00750a02"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-central-2', '{"image_id": "ami-0e058ee110e570f72"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-west-1', '{"image_id": "ami-003c6328b40ce2af6"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-west-2', '{"image_id": "ami-0d05d6fe284781e13"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-west-3', '{"image_id": "ami-061fc0c4ca50c3135"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-north-1', '{"image_id": "ami-0c0a1c5b612d238ae"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-south-1', '{"image_id": "ami-02b44d454d6fdf306"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'eu-south-2', '{"image_id": "ami-0d4fc4ae17783f6bc"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'me-south-1', '{"image_id": "ami-01a4b9ac29969a669"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'me-central-1', '{"image_id": "ami-0934b7ea698655531"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'us-east-1', '{"image_id": "ami-012485deee5681dc0"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'us-east-2', '{"image_id": "ami-0df0b6b7f8f5ea0d0"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'us-west-1', '{"image_id": "ami-0344e2943d3053eda"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'us-west-2', '{"image_id": "ami-0526a31610d9ba25a"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ca-central-1', '{"image_id": "ami-0bb0ed6088d3b1bec"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'ca-west-1', '{"image_id": "ami-084542ffdec042eef"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('aws', 'sa-east-1', '{"image_id": "ami-08df96b48d7147886"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('gcp', 'all', '{"source_image": "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('azure', 'all', '{"offer": "0001-com-ubuntu-server-jammy", "publisher": "Canonical", "sku": "22_04-lts-gen2", "version": "latest"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('digitalocean', 'all', '{"image_name": "ubuntu-22-04-x64"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15'),
    ('hetzner', 'all', '{"image_name": "ubuntu-22.04"}', 'amd64', 'Ubuntu', '22.04 LTS', '2024-05-15');

ALTER TABLE ONLY public.cloud_images
    ADD CONSTRAINT cloud_images_pkey PRIMARY KEY (cloud_provider, image);

ALTER TABLE ONLY public.cloud_images
    ADD CONSTRAINT cloud_images_cloud_provider_fkey FOREIGN KEY (cloud_provider) REFERENCES public.cloud_providers(provider_name);
