-- +goose Up

-- Create extensions
CREATE SCHEMA IF NOT EXISTS extensions;
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA extensions;

-- cloud_providers
CREATE TABLE public.cloud_providers (
    provider_name text NOT NULL,
    provider_description text NOT NULL,
    provider_image text
);

COMMENT ON TABLE public.cloud_providers IS 'Table containing cloud providers information';
COMMENT ON COLUMN public.cloud_providers.provider_name IS 'The name of the cloud provider';
COMMENT ON COLUMN public.cloud_providers.provider_description IS 'A description of the cloud provider';

INSERT INTO public.cloud_providers (provider_name, provider_description, provider_image) VALUES
    ('aws', 'Amazon Web Services', 'aws.png'),
    ('gcp', 'Google Cloud Platform', 'gcp.png'),
    ('azure', 'Microsoft Azure', 'azure.png'),
    ('digitalocean', 'DigitalOcean', 'digitalocean.png'),
    ('hetzner', 'Hetzner Cloud', 'hetzner.png');

ALTER TABLE ONLY public.cloud_providers
    ADD CONSTRAINT cloud_providers_pkey PRIMARY KEY (provider_name);


-- cloud_regions
CREATE TABLE public.cloud_regions (
    cloud_provider text NOT NULL,
    region_group text NOT NULL,
    region_name text NOT NULL,
    region_description text NOT NULL
);

COMMENT ON TABLE public.cloud_regions IS 'Table containing cloud regions information for various cloud providers';
COMMENT ON COLUMN public.cloud_regions.cloud_provider IS 'The name of the cloud provider';
COMMENT ON COLUMN public.cloud_regions.region_group IS 'The geographical group of the cloud region';
COMMENT ON COLUMN public.cloud_regions.region_name IS 'The specific name of the cloud region';
COMMENT ON COLUMN public.cloud_regions.region_description IS 'A description of the cloud region';

INSERT INTO public.cloud_regions (cloud_provider, region_group, region_name, region_description) VALUES
    ('aws', 'Africa', 'af-south-1', 'Africa (Cape Town)'),
    ('aws', 'Asia Pacific', 'ap-east-1', 'Asia Pacific (Hong Kong)'),
    ('aws', 'Asia Pacific', 'ap-south-1', 'Asia Pacific (Mumbai)'),
    ('aws', 'Asia Pacific', 'ap-south-2', 'Asia Pacific (Hyderabad)'),
    ('aws', 'Asia Pacific', 'ap-southeast-3', 'Asia Pacific (Jakarta)'),
    ('aws', 'Asia Pacific', 'ap-southeast-4', 'Asia Pacific (Melbourne)'),
    ('aws', 'Asia Pacific', 'ap-northeast-1', 'Asia Pacific (Tokyo)'),
    ('aws', 'Asia Pacific', 'ap-northeast-2', 'Asia Pacific (Seoul)'),
    ('aws', 'Asia Pacific', 'ap-northeast-3', 'Asia Pacific (Osaka)'),
    ('aws', 'Asia Pacific', 'ap-southeast-1', 'Asia Pacific (Singapore)'),
    ('aws', 'Asia Pacific', 'ap-southeast-2', 'Asia Pacific (Sydney)'),
    ('aws', 'Europe', 'eu-central-1', 'Europe (Frankfurt)'),
    ('aws', 'Europe', 'eu-west-1', 'Europe (Ireland)'),
    ('aws', 'Europe', 'eu-west-2', 'Europe (London)'),
    ('aws', 'Europe', 'eu-west-3', 'Europe (Paris)'),
    ('aws', 'Europe', 'eu-north-1', 'Europe (Stockholm)'),
    ('aws', 'Europe', 'eu-south-1', 'Europe (Milan)'),
    ('aws', 'Europe', 'eu-south-2', 'Europe (Spain)'),
    ('aws', 'Europe', 'eu-central-2', 'Europe (Zurich)'),
    ('aws', 'Middle East', 'me-south-1', 'Middle East (Bahrain)'),
    ('aws', 'Middle East', 'me-central-1', 'Middle East (UAE)'),
    ('aws', 'North America', 'us-east-1', 'US East (N. Virginia)'),
    ('aws', 'North America', 'us-east-2', 'US East (Ohio)'),
    ('aws', 'North America', 'us-west-1', 'US West (N. California)'),
    ('aws', 'North America', 'us-west-2', 'US West (Oregon)'),
    ('aws', 'North America', 'ca-central-1', 'Canada (Central)'),
    ('aws', 'North America', 'ca-west-1', 'Canada (Calgary)'),
    ('aws', 'South America', 'sa-east-1', 'South America (São Paulo)'),
    ('gcp', 'Africa', 'africa-south1', 'Johannesburg'),
    ('gcp', 'Asia Pacific', 'asia-east1', 'Taiwan'),
    ('gcp', 'Asia Pacific', 'asia-east2', 'Hong Kong'),
    ('gcp', 'Asia Pacific', 'asia-northeast1', 'Tokyo'),
    ('gcp', 'Asia Pacific', 'asia-northeast2', 'Osaka'),
    ('gcp', 'Asia Pacific', 'asia-northeast3', 'Seoul'),
    ('gcp', 'Asia Pacific', 'asia-south1', 'Mumbai'),
    ('gcp', 'Asia Pacific', 'asia-south2', 'Delhi'),
    ('gcp', 'Asia Pacific', 'asia-southeast1', 'Singapore'),
    ('gcp', 'Asia Pacific', 'asia-southeast2', 'Jakarta'),
    ('gcp', 'Australia', 'australia-southeast1', 'Sydney'),
    ('gcp', 'Australia', 'australia-southeast2', 'Melbourne'),
    ('gcp', 'Europe', 'europe-central2', 'Warsaw'),
    ('gcp', 'Europe', 'europe-north1', 'Finland'),
    ('gcp', 'Europe', 'europe-southwest1', 'Madrid'),
    ('gcp', 'Europe', 'europe-west1', 'Belgium'),
    ('gcp', 'Europe', 'europe-west10', 'Berlin'),
    ('gcp', 'Europe', 'europe-west12', 'Turin'),
    ('gcp', 'Europe', 'europe-west2', 'London'),
    ('gcp', 'Europe', 'europe-west3', 'Frankfurt'),
    ('gcp', 'Europe', 'europe-west4', 'Netherlands'),
    ('gcp', 'Europe', 'europe-west6', 'Zurich'),
    ('gcp', 'Europe', 'europe-west8', 'Milan'),
    ('gcp', 'Europe', 'europe-west9', 'Paris'),
    ('gcp', 'Middle East', 'me-central1', 'Doha'),
    ('gcp', 'Middle East', 'me-central2', 'Dammam'),
    ('gcp', 'Middle East', 'me-west1', 'Tel Aviv'),
    ('gcp', 'North America', 'northamerica-northeast1', 'Montréal'),
    ('gcp', 'North America', 'northamerica-northeast2', 'Toronto'),
    ('gcp', 'North America', 'us-central1', 'Iowa'),
    ('gcp', 'North America', 'us-east1', 'South Carolina'),
    ('gcp', 'North America', 'us-east4', 'Northern Virginia'),
    ('gcp', 'North America', 'us-east5', 'Columbus'),
    ('gcp', 'North America', 'us-south1', 'Dallas'),
    ('gcp', 'North America', 'us-west1', 'Oregon'),
    ('gcp', 'North America', 'us-west2', 'Los Angeles'),
    ('gcp', 'North America', 'us-west3', 'Salt Lake City'),
    ('gcp', 'North America', 'us-west4', 'Las Vegas'),
    ('gcp', 'South America', 'southamerica-east1', 'São Paulo'),
    ('gcp', 'South America', 'southamerica-west1', 'Santiago'),
    ('azure', 'Africa', 'southafricanorth', 'South Africa North (Johannesburg)'),
    ('azure', 'Africa', 'southafricawest', 'South Africa West (Cape Town)'),
    ('azure', 'Asia Pacific', 'australiacentral', 'Australia Central (Canberra)'),
    ('azure', 'Asia Pacific', 'australiacentral2', 'Australia Central 2 (Canberra)'),
    ('azure', 'Asia Pacific', 'australiaeast', 'Australia East (New South Wales)'),
    ('azure', 'Asia Pacific', 'australiasoutheast', 'Australia Southeast (Victoria)'),
    ('azure', 'Asia Pacific', 'centralindia', 'Central India (Pune)'),
    ('azure', 'Asia Pacific', 'eastasia', 'East Asia (Hong Kong)'),
    ('azure', 'Asia Pacific', 'japaneast', 'Japan East (Tokyo, Saitama)'),
    ('azure', 'Asia Pacific', 'japanwest', 'Japan West (Osaka)'),
    ('azure', 'Asia Pacific', 'jioindiacentral', 'Jio India Central (Nagpur)'),
    ('azure', 'Asia Pacific', 'jioindiawest', 'Jio India West (Jamnagar)'),
    ('azure', 'Asia Pacific', 'koreacentral', 'Korea Central (Seoul)'),
    ('azure', 'Asia Pacific', 'koreasouth', 'Korea South (Busan)'),
    ('azure', 'Asia Pacific', 'southeastasia', 'Southeast Asia (Singapore)'),
    ('azure', 'Asia Pacific', 'southindia', 'South India (Chennai)'),
    ('azure', 'Asia Pacific', 'westindia', 'West India (Mumbai)'),
    ('azure', 'Europe', 'francecentral', 'France Central (Paris)'),
    ('azure', 'Europe', 'francesouth', 'France South (Marseille)'),
    ('azure', 'Europe', 'germanynorth', 'Germany North (Berlin)'),
    ('azure', 'Europe', 'germanywestcentral', 'Germany West Central (Frankfurt)'),
    ('azure', 'Europe', 'italynorth', 'Italy North (Milan)'),
    ('azure', 'Europe', 'northeurope', 'North Europe (Ireland)'),
    ('azure', 'Europe', 'norwayeast', 'Norway East (Norway)'),
    ('azure', 'Europe', 'norwaywest', 'Norway West (Norway)'),
    ('azure', 'Europe', 'polandcentral', 'Poland Central (Warsaw)'),
    ('azure', 'Europe', 'swedencentral', 'Sweden Central (Gävle)'),
    ('azure', 'Europe', 'switzerlandnorth', 'Switzerland North (Zurich)'),
    ('azure', 'Europe', 'switzerlandwest', 'Switzerland West (Geneva)'),
    ('azure', 'Europe', 'uksouth', 'UK South (London)'),
    ('azure', 'Europe', 'ukwest', 'UK West (Cardiff)'),
    ('azure', 'Europe', 'westeurope', 'West Europe (Netherlands)'),
    ('azure', 'Mexico', 'mexicocentral', 'Mexico Central (Querétaro State)'),
    ('azure', 'Middle East', 'qatarcentral', 'Qatar Central (Doha)'),
    ('azure', 'Middle East', 'uaecentral', 'UAE Central (Abu Dhabi)'),
    ('azure', 'Middle East', 'uaenorth', 'UAE North (Dubai)'),
    ('azure', 'South America', 'brazilsouth', 'Brazil South (Sao Paulo State)'),
    ('azure', 'South America', 'brazilsoutheast', 'Brazil Southeast (Rio)'),
    ('azure', 'North America', 'centralus', 'Central US (Iowa)'),
    ('azure', 'North America', 'eastus', 'East US (Virginia)'),
    ('azure', 'North America', 'eastus2', 'East US 2 (Virginia)'),
    ('azure', 'North America', 'eastusstg', 'East US STG (Virginia)'),
    ('azure', 'North America', 'northcentralus', 'North Central US (Illinois)'),
    ('azure', 'North America', 'southcentralus', 'South Central US (Texas)'),
    ('azure', 'North America', 'westcentralus', 'West Central US (Wyoming)'),
    ('azure', 'North America', 'westus', 'West US (California)'),
    ('azure', 'North America', 'westus2', 'West US 2 (Washington)'),
    ('azure', 'North America', 'westus3', 'West US 3 (Phoenix)'),
    ('azure', 'North America', 'canadaeast', 'Canada East (Quebec)'),
    ('azure', 'North America', 'canadacentral', 'Canada Central (Toronto)'),
    ('azure', 'South America', 'brazilus', 'Brazil US (South America)'),
    ('digitalocean', 'Asia Pacific', 'sgp1', 'Singapore (Datacenter 1)'),
    ('digitalocean', 'Asia Pacific', 'blr1', 'Bangalore (Datacenter 1)'),
    ('digitalocean', 'Australia', 'syd1', 'Sydney (Datacenter 1)'),
    ('digitalocean', 'Europe', 'ams3', 'Amsterdam (Datacenter 3)'),
    ('digitalocean', 'Europe', 'lon1', 'London (Datacenter 1)'),
    ('digitalocean', 'Europe', 'fra1', 'Frankfurt (Datacenter 1)'),
    ('digitalocean', 'North America', 'nyc1', 'New York (Datacenter 1)'),
    ('digitalocean', 'North America', 'nyc3', 'New York (Datacenter 3)'),
    ('digitalocean', 'North America', 'sfo2', 'San Francisco (Datacenter 2)'),
    ('digitalocean', 'North America', 'sfo3', 'San Francisco (Datacenter 3)'),
    ('digitalocean', 'North America', 'tor1', 'Toronto (Datacenter 1)'),
    ('hetzner', 'Europe', 'nbg1', 'Nuremberg'),
    ('hetzner', 'Europe', 'zfsn1', 'Falkenstein'),
    ('hetzner', 'Europe', 'hel1', 'Helsinki'),
    ('hetzner', 'North America', 'hil', 'Hillsboro, OR'),
    ('hetzner', 'North America', 'ash', 'Ashburn, VA');

ALTER TABLE ONLY public.cloud_regions
    ADD CONSTRAINT cloud_regions_pkey PRIMARY KEY (cloud_provider, region_group, region_name);

ALTER TABLE ONLY public.cloud_regions
    ADD CONSTRAINT cloud_regions_cloud_provider_fkey FOREIGN KEY (cloud_provider) REFERENCES public.cloud_providers(provider_name);


-- cloud_instances
CREATE TABLE public.cloud_instances (
    cloud_provider text NOT NULL,
    instance_group text NOT NULL,
    instance_name text NOT NULL,
    arch text DEFAULT 'amd64' NOT NULL,
    cpu integer NOT NULL,
    ram integer NOT NULL,
    price_hourly numeric NOT NULL,
    price_monthly numeric NOT NULL,
    currency CHAR(1) DEFAULT '$' NOT NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.cloud_instances IS 'Table containing cloud instances information for various cloud providers';
COMMENT ON COLUMN public.cloud_instances.cloud_provider IS 'The name of the cloud provider';
COMMENT ON COLUMN public.cloud_instances.instance_group IS 'The group of the instance size';
COMMENT ON COLUMN public.cloud_instances.instance_name IS 'The specific name of the cloud instance';
COMMENT ON COLUMN public.cloud_instances.arch IS 'The architecture of the instance';
COMMENT ON COLUMN public.cloud_instances.cpu IS 'The number of CPUs of the instance';
COMMENT ON COLUMN public.cloud_instances.ram IS 'The amount of RAM (in GB) of the instance';
COMMENT ON COLUMN public.cloud_instances.price_hourly IS 'The hourly price of the instance';
COMMENT ON COLUMN public.cloud_instances.price_monthly IS 'The monthly price of the instance';
COMMENT ON COLUMN public.cloud_instances.currency IS 'The currency of the price (default: $)';
COMMENT ON COLUMN public.cloud_instances.updated_at IS 'The date when the instance information was last updated';

-- The price is approximate because it is specified for one region and may differ in other regions.
-- aws, gcp, azure: the price is for the region 'US East'
INSERT INTO public.cloud_instances (cloud_provider, instance_group, instance_name, cpu, ram, price_hourly, price_monthly, currency, updated_at) VALUES
    ('aws', 'Small Size', 't3.small', 2, 2, 0.021, 14.976, '$', '2024-05-15'),
    ('aws', 'Small Size', 't3.medium', 2, 4, 0.042, 29.952, '$', '2024-05-15'),
    ('aws', 'Small Size', 'm6i.large', 2, 8, 0.096, 69.120, '$', '2024-05-15'),
    ('aws', 'Small Size', 'r6i.large', 2, 16, 0.126, 90.720, '$', '2024-05-15'),
    ('aws', 'Small Size', 'm6i.xlarge', 4, 16, 0.192, 138.240, '$', '2024-05-15'),
    ('aws', 'Small Size', 'r6i.xlarge', 4, 32, 0.252, 181.440, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'm6i.2xlarge', 8, 32, 0.384, 276.480, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'r6i.2xlarge', 8, 64, 0.504, 362.880, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'm6i.4xlarge', 16, 64, 0.768, 552.960, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'r6i.4xlarge', 16, 128, 1.008, 725.760, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'm6i.8xlarge', 32, 128, 1.536, 1105.920, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'r6i.8xlarge', 32, 256, 2.016, 1451.520, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'm6i.12xlarge', 48, 192, 2.304, 1658.880, '$', '2024-05-15'),
    ('aws', 'Medium Size', 'r6i.12xlarge', 48, 384, 3.024, 2177.280, '$', '2024-05-15'),
    ('aws', 'Large Size', 'm6i.16xlarge', 64, 256, 3.072, 2211.840, '$', '2024-05-15'),
    ('aws', 'Large Size', 'r6i.16xlarge', 64, 512, 4.032, 2903.040, '$', '2024-05-15'),
    ('aws', 'Large Size', 'm6i.24xlarge', 96, 384, 4.608, 3317.760, '$', '2024-05-15'),
    ('aws', 'Large Size', 'r6i.24xlarge', 96, 768, 6.048, 4354.560, '$', '2024-05-15'),
    ('aws', 'Large Size', 'm6i.32xlarge', 128, 512, 6.144, 4423.680, '$', '2024-05-15'),
    ('aws', 'Large Size', 'r6i.32xlarge', 128, 1024, 8.064, 5806.080, '$', '2024-05-15'),
    ('aws', 'Large Size', 'm7i.48xlarge', 192, 768, 9.677, 6967.296, '$', '2024-05-15'),
    ('aws', 'Large Size', 'r7i.48xlarge', 192, 1536, 12.701, 9144.576, '$', '2024-05-15'),
    ('gcp', 'Small Size', 'e2-small', 2, 2, 0.017, 12.228, '$', '2024-05-15'),
    ('gcp', 'Small Size', 'e2-medium', 2, 4, 0.034, 24.457, '$', '2024-05-15'),
    ('gcp', 'Small Size', 'n2-standard-2', 2, 8, 0.097, 70.896, '$', '2024-05-15'),
    ('gcp', 'Small Size', 'n2-highmem-2', 2, 16, 0.131, 95.640, '$', '2024-05-15'),
    ('gcp', 'Small Size', 'n2-standard-4', 4, 16, 0.194, 141.792, '$', '2024-05-15'),
    ('gcp', 'Small Size', 'n2-highmem-4', 4, 32, 0.262, 191.280, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-standard-8', 8, 32, 0.388, 283.585, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-highmem-8', 8, 64, 0.524, 382.561, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-standard-16', 16, 64, 0.777, 567.169, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-highmem-16', 16, 128, 1.048, 765.122, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-standard-32', 32, 128, 1.554, 1134.338, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-highmem-32', 32, 256, 2.096, 1530.244, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-standard-48', 48, 192, 2.331, 1701.507, '$', '2024-05-15'),
    ('gcp', 'Medium Size', 'n2-highmem-48', 48, 384, 3.144, 2295.365, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-standard-64', 64, 256, 3.108, 2268.676, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-highmem-64', 64, 512, 4.192, 3060.487, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-standard-80', 80, 320, 3.885, 2835.846, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-highmem-80', 80, 640, 5.241, 3825.609, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-standard-96', 96, 384, 4.662, 3403.015, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-highmem-96', 96, 768, 6.289, 4590.731, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-standard-128', 128, 512, 6.216, 4537.353, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'n2-highmem-128', 128, 864, 7.707, 5626.092, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'c3-standard-176', 176, 704, 9.188, 6706.913, '$', '2024-05-15'),
    ('gcp', 'Large Size', 'c3-highmem-176', 176, 1408, 12.394, 9047.819, '$', '2024-05-15'),
    ('azure', 'Small Size', 'Standard_B1ms', 1, 2, 0.021, 15.111, '$', '2024-05-15'),
    ('azure', 'Small Size', 'Standard_B2s', 2, 4, 0.042, 30.368, '$', '2024-05-15'),
    ('azure', 'Small Size', 'Standard_D2s_v5', 2, 8, 0.096, 70.080, '$', '2024-05-15'),
    ('azure', 'Small Size', 'Standard_E2s_v5', 2, 16, 0.126, 91.980, '$', '2024-05-15'),
    ('azure', 'Small Size', 'Standard_D4s_v5', 4, 16, 0.192, 140.160, '$', '2024-05-15'),
    ('azure', 'Small Size', 'Standard_E4s_v5', 4, 32, 0.252, 183.960, '$', '2024-05-15'),
    ('azure', 'Medium Size', 'Standard_D8s_v5', 8, 32, 0.384, 280.320, '$', '2024-05-15'),
    ('azure', 'Medium Size', 'Standard_E8s_v5', 8, 64, 0.504, 367.920, '$', '2024-05-15'),
    ('azure', 'Medium Size', 'Standard_D16s_v5', 16, 64, 0.768, 560.640, '$', '2024-05-15'),
    ('azure', 'Medium Size', 'Standard_E16s_v5', 16, 128, 1.008, 735.840, '$', '2024-05-15'),
    ('azure', 'Medium Size', 'Standard_D32s_v5', 32, 128, 1.536, 1121.280, '$', '2024-05-15'),
    ('azure', 'Medium Size', 'Standard_E32s_v5', 32, 256, 2.016, 1471.680, '$', '2024-05-15'),
    ('azure', 'Large Size', 'Standard_D48s_v5', 48, 192, 2.304, 1681.920, '$', '2024-05-15'),
    ('azure', 'Large Size', 'Standard_E48s_v5', 48, 384, 3.024, 2207.520, '$', '2024-05-15'),
    ('azure', 'Large Size', 'Standard_D64s_v5', 64, 256, 3.072, 2242.560, '$', '2024-05-15'),
    ('azure', 'Large Size', 'Standard_E64s_v5', 64, 512, 4.032, 2943.360, '$', '2024-05-15'),
    ('azure', 'Large Size', 'Standard_D96s_v5', 96, 384, 4.608, 3363.840, '$', '2024-05-15'),
    ('azure', 'Large Size', 'Standard_E96s_v5', 96, 672, 6.048, 4415.040, '$', '2024-05-15'),
    ('digitalocean', 'Small Size', 's-2vcpu-2gb', 2, 2, 0.027, 18.000, '$', '2024-05-15'),
    ('digitalocean', 'Small Size', 's-2vcpu-4gb', 2, 4, 0.036, 24.000, '$', '2024-05-15'),
    ('digitalocean', 'Small Size', 'g-2vcpu-8gb', 2, 8, 0.094, 63.000, '$', '2024-05-15'),
    ('digitalocean', 'Small Size', 'm-2vcpu-16gb', 2, 16, 0.125, 84.000, '$', '2024-05-15'),
    ('digitalocean', 'Small Size', 'g-4vcpu-16gb', 4, 16, 0.188, 126.000, '$', '2024-05-15'),
    ('digitalocean', 'Small Size', 'm-4vcpu-32gb', 4, 32, 0.250, 168.000, '$', '2024-05-15'),
    ('digitalocean', 'Medium Size', 'g-8vcpu-32gb', 8, 32, 0.375, 252.000, '$', '2024-05-15'),
    ('digitalocean', 'Medium Size', 'm-8vcpu-64gb', 8, 64, 0.500, 336.000, '$', '2024-05-15'),
    ('digitalocean', 'Medium Size', 'g-16vcpu-64gb', 16, 64, 0.750, 504.000, '$', '2024-05-15'),
    ('digitalocean', 'Medium Size', 'm-16vcpu-128gb', 16, 128, 1.000, 672.000, '$', '2024-05-15'),
    ('digitalocean', 'Medium Size', 'g-32vcpu-128gb', 32, 128, 1.500, 1008.000, '$', '2024-05-15'),
    ('digitalocean', 'Medium Size', 'm-32vcpu-256gb', 32, 256, 2.000, 1344.000, '$', '2024-05-15'),
    ('digitalocean', 'Medium Size', 'g-48vcpu-192gb', 48, 192, 2.699, 1814.000, '$', '2024-05-15'),
    ('hetzner', 'Small Size', 'CX11', 1, 2, 0.007, 4.510, '€', '2024-05-15'),
    ('hetzner', 'Small Size', 'CX21', 2, 4, 0.010, 6.370, '€', '2024-05-15'),
    ('hetzner', 'Small Size', 'CCX13', 2, 8, 0.024, 14.860, '€', '2024-05-15'),
    ('hetzner', 'Small Size', 'CCX23', 4, 16, 0.047, 29.140, '€', '2024-05-15'),
    ('hetzner', 'Medium Size', 'CCX33', 8, 32, 0.093, 57.700, '€', '2024-05-15'),
    ('hetzner', 'Medium Size', 'CCX43', 16, 64, 0.184, 114.820, '€', '2024-05-15'),
    ('hetzner', 'Medium Size', 'CCX53', 32, 128, 0.367, 229.060, '€', '2024-05-15'),
    ('hetzner', 'Medium Size', 'CCX63', 48, 192, 0.550, 343.300, '€', '2024-05-15');

ALTER TABLE ONLY public.cloud_instances
    ADD CONSTRAINT cloud_instances_pkey PRIMARY KEY (cloud_provider, instance_group, instance_name);

ALTER TABLE ONLY public.cloud_instances
    ADD CONSTRAINT cloud_instances_cloud_provider_fkey FOREIGN KEY (cloud_provider) REFERENCES public.cloud_providers(provider_name);

-- this trigger will set the "updated_at" column to the current timestamp for every update
CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.cloud_instances
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);


-- cloud_volumes
CREATE TABLE public.cloud_volumes (
    cloud_provider text NOT NULL,
    volume_type text NOT NULL,
    volume_description text NOT NULL,
    volume_min_size integer NOT NULL,
    volume_max_size integer NOT NULL,
    price_monthly numeric NOT NULL,
    currency CHAR(1) DEFAULT '$' NOT NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

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

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.cloud_volumes
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);


-- cloud_images
CREATE TABLE public.cloud_images (
    cloud_provider text NOT NULL,
    region text NOT NULL,
    image jsonb NOT NULL,
    arch text DEFAULT 'amd64' NOT NULL,
    os_name text NOT NULL,
    os_version text NOT NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.cloud_images IS 'Table containing cloud images information for various cloud providers';
COMMENT ON COLUMN public.cloud_images.cloud_provider IS 'The name of the cloud provider';
COMMENT ON COLUMN public.cloud_images.region IS 'The region where the image is available';
COMMENT ON COLUMN public.cloud_images.image IS 'The image details in JSON format';
COMMENT ON COLUMN public.cloud_images.arch IS 'The architecture of the operating system (default: amd64)';
COMMENT ON COLUMN public.cloud_images.os_name IS 'The name of the operating system';
COMMENT ON COLUMN public.cloud_images.os_version IS 'The version of the operating system';
COMMENT ON COLUMN public.cloud_images.updated_at IS 'The date when the image information was last updated';

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

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.cloud_images
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);


-- Projects
CREATE TABLE public.projects (
    project_id bigserial PRIMARY KEY,
    project_name varchar(50) NOT NULL UNIQUE,
    project_description varchar(150),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp
);

COMMENT ON TABLE public.projects IS 'Table containing information about projects';
COMMENT ON COLUMN public.projects.project_name IS 'The name of the project';
COMMENT ON COLUMN public.projects.project_description IS 'A description of the project';
COMMENT ON COLUMN public.projects.created_at IS 'The timestamp when the project was created';
COMMENT ON COLUMN public.projects.updated_at IS 'The timestamp when the project was last updated';

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.projects
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);

INSERT INTO public.projects (project_name) VALUES ('default');


-- Environments
CREATE TABLE public.environments (
    environment_id bigserial PRIMARY KEY,
    environment_name varchar(20) NOT NULL,
    environment_description text,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp
);

COMMENT ON TABLE public.environments IS 'Table containing information about environments';
COMMENT ON COLUMN public.environments.environment_name IS 'The name of the environment';
COMMENT ON COLUMN public.environments.environment_description IS 'A description of the environment';
COMMENT ON COLUMN public.environments.created_at IS 'The timestamp when the environment was created';
COMMENT ON COLUMN public.environments.updated_at IS 'The timestamp when the environment was last updated';

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.environments
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);

CREATE INDEX environments_name_idx ON public.environments (environment_name);

INSERT INTO public.environments (environment_name) VALUES ('production');
INSERT INTO public.environments (environment_name) VALUES ('staging');
INSERT INTO public.environments (environment_name) VALUES ('test');
INSERT INTO public.environments (environment_name) VALUES ('dev');
INSERT INTO public.environments (environment_name) VALUES ('benchmarking');


-- Secrets
CREATE TABLE public.secrets (
    secret_id bigserial PRIMARY KEY,
    project_id bigint REFERENCES public.projects(project_id),
    secret_type text NOT NULL,
    secret_name text NOT NULL UNIQUE,
    secret_value bytea NOT NULL,  -- Encrypted data
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp
);

COMMENT ON TABLE public.secrets IS 'Table containing secrets for accessing cloud providers and servers';
COMMENT ON COLUMN public.secrets.project_id IS 'The ID of the project to which the secret belongs';
COMMENT ON COLUMN public.secrets.secret_type IS 'The type of the secret (e.g., cloud_secret, ssh_key, password)';
COMMENT ON COLUMN public.secrets.secret_name IS 'The name of the secret';
COMMENT ON COLUMN public.secrets.secret_value IS 'The encrypted value of the secret';
COMMENT ON COLUMN public.secrets.created_at IS 'The timestamp when the secret was created';
COMMENT ON COLUMN public.secrets.updated_at IS 'The timestamp when the secret was last updated';

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.secrets
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);

CREATE INDEX secrets_type_name_idx ON public.secrets (secret_type, secret_name);
CREATE INDEX secrets_id_project_idx ON public.secrets (secret_id, project_id);
CREATE INDEX secrets_project_idx ON public.secrets (project_id);

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION add_secret(p_project_id bigint, p_secret_type text, p_secret_name text, p_secret_value text, p_encryption_key text)
RETURNS bigint AS $$
DECLARE
    v_inserted_secret_id bigint;
BEGIN
    INSERT INTO public.secrets (project_id, secret_type, secret_name, secret_value)
    VALUES (p_project_id, p_secret_type, p_secret_name, extensions.pgp_sym_encrypt(p_secret_value, p_encryption_key, 'cipher-algo=aes256'))
    RETURNING secret_id INTO v_inserted_secret_id;
    
    RETURN v_inserted_secret_id;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION update_secret(
    p_secret_id bigint,
    p_secret_type text DEFAULT NULL,
    p_secret_name text DEFAULT NULL,
    p_secret_value text DEFAULT NULL,
    p_encryption_key text DEFAULT NULL
)
RETURNS TABLE (
    project_id bigint,
    secret_id bigint,
    secret_type text,
    secret_name text,
    created_at timestamp,
    updated_at timestamp,
    used boolean,
    used_by_clusters text,
    used_by_servers text
) AS $$
BEGIN
    IF p_secret_value IS NOT NULL AND p_encryption_key IS NULL THEN
        RAISE EXCEPTION 'Encryption key must be provided when updating secret value';
    END IF;

    UPDATE public.secrets
    SET 
        secret_name = COALESCE(p_secret_name, public.secrets.secret_name),
        secret_type = COALESCE(p_secret_type, public.secrets.secret_type),
        secret_value = CASE 
                          WHEN p_secret_value IS NOT NULL THEN extensions.pgp_sym_encrypt(p_secret_value, p_encryption_key, 'cipher-algo=aes256')
                          ELSE public.secrets.secret_value 
                       END
    WHERE public.secrets.secret_id = p_secret_id;

    RETURN QUERY
    SELECT 
        s.project_id,
        s.secret_id,
        s.secret_type,
        s.secret_name,
        s.created_at,
        s.updated_at,
        s.used,
        s.used_by_clusters,
        s.used_by_servers
    FROM
        public.v_secrets_list s
    WHERE s.secret_id = p_secret_id;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION get_secret(p_secret_id bigint, p_encryption_key text)
RETURNS json AS $$
DECLARE
    decrypted_value json;
BEGIN
    SELECT extensions.pgp_sym_decrypt(secret_value, p_encryption_key)::json
    INTO decrypted_value
    FROM public.secrets
    WHERE secret_id = p_secret_id;
    
    RETURN decrypted_value;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- An example of using a function to insert a secret (value in JSON format)
-- SELECT add_secret(<project_id>, 'ssh_key', '<secret_name>', '{"private_key": "<CONTENT>"}', '<encryption_key>');
-- SELECT add_secret(<project_id>, 'password', '<secret_name>', '{"username": "<CONTENT>", "password": "<CONTENT>"}', '<encryption_key>');
-- SELECT add_secret(<project_id>, 'aws', '<secret_name>', '{"AWS_ACCESS_KEY_ID": "<CONTENT>", "AWS_SECRET_ACCESS_KEY": "<CONTENT>"}', '<encryption_key>');

-- An example of using the function to update a secret
-- SELECT update_secret(<secret_id>, '<new_secret_type>', '<new_secret_name>', '<new_secret_value>', '<encryption_key>');

-- An example of using a function to get a secret
-- SELECT get_secret(<secret_id>, '<encryption_key>');


-- Clusters
CREATE TABLE public.clusters (
    cluster_id bigserial PRIMARY KEY,
    project_id bigint REFERENCES public.projects(project_id),
    environment_id bigint REFERENCES public.environments(environment_id),
    cluster_name text NOT NULL UNIQUE,
    cluster_description text,
    cluster_details jsonb,
    extra_vars jsonb,
    location text,
    server_count integer DEFAULT 0,
    secret_id bigint REFERENCES public.secrets(secret_id),  -- link to the secret for accessing the cloud provider
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp
);

COMMENT ON TABLE public.clusters IS 'Table containing information about Postgres clusters';
COMMENT ON COLUMN public.clusters.project_id IS 'The ID of the project to which the cluster belongs';
COMMENT ON COLUMN public.clusters.environment_id IS 'The environment in which the cluster is deployed (e.g., Production, Development)';
COMMENT ON COLUMN public.clusters.cluster_name IS 'The name of the cluster (it must be unique)';
COMMENT ON COLUMN public.clusters.cluster_description IS 'A description of the cluster (optional)';
COMMENT ON COLUMN public.clusters.cluster_details IS 'Additional information about the cluster (cloud provider, instance type, postgres version, connection info, etc.)';
COMMENT ON COLUMN public.clusters.extra_vars IS 'Extra variables for Ansible specific to this cluster';
COMMENT ON COLUMN public.clusters.location IS 'The region/datacenter where the cluster is located';
COMMENT ON COLUMN public.clusters.server_count IS 'The number of servers associated with the cluster';
COMMENT ON COLUMN public.clusters.secret_id IS 'The ID of the secret for accessing the cloud provider';
COMMENT ON COLUMN public.clusters.created_at IS 'The timestamp when the cluster was created';
COMMENT ON COLUMN public.clusters.updated_at IS 'The timestamp when the cluster was last updated';

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.clusters
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);

CREATE INDEX clusters_id_project_id_idx ON public.clusters (cluster_id, project_id);
CREATE INDEX clusters_project_idx ON public.clusters (project_id);
CREATE INDEX clusters_environment_idx ON public.clusters (environment_id);
CREATE INDEX clusters_name_idx ON public.clusters (cluster_name);
CREATE INDEX clusters_secret_id_idx ON public.clusters (secret_id);


-- Cluster servers
CREATE TABLE public.servers (
    server_id bigserial PRIMARY KEY,
    cluster_id bigint REFERENCES public.clusters(cluster_id),
    server_name text NOT NULL,
    server_location text,
    ip_address inet NOT NULL,
    postgresql_exists boolean DEFAULT false,
    host_groups jsonb,
    host_vars jsonb,
    role text DEFAULT 'N/A',
    status text DEFAULT 'N/A',
    secret_id bigint REFERENCES public.secrets(secret_id),  -- link to the secret for SSH access
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp
);

COMMENT ON TABLE public.servers IS 'Table containing information about servers within a Postgres cluster';
COMMENT ON COLUMN public.servers.cluster_id IS 'The ID of the cluster to which the server belongs';
COMMENT ON COLUMN public.servers.server_name IS 'The name of the server';
COMMENT ON COLUMN public.servers.server_location IS 'The physical or cloud location of the server';
COMMENT ON COLUMN public.servers.ip_address IS 'The IP address of the server';
COMMENT ON COLUMN public.servers.postgresql_exists IS 'Indicates whether Postgres database already exists (to convert a standard Postgres setup to a HA cluster)';
COMMENT ON COLUMN public.servers.host_groups IS 'JSONB field containing the Ansible host groups to which the server belongs';
COMMENT ON COLUMN public.servers.host_vars IS 'JSONB field containing Ansible host-specific variables';
COMMENT ON COLUMN public.servers.role IS 'The role of the server (e.g., primary, replica)';
COMMENT ON COLUMN public.servers.status IS 'The current status of the server';
COMMENT ON COLUMN public.servers.secret_id IS 'The ID of the secret for accessing the server via SSH';
COMMENT ON COLUMN public.servers.created_at IS 'The timestamp when the server was created';
COMMENT ON COLUMN public.servers.updated_at IS 'The timestamp when the server was last updated';

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.servers
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);

CREATE INDEX servers_cluster_id_idx ON public.servers (cluster_id);
CREATE INDEX servers_secret_id_idx ON public.servers (secret_id);

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION update_server_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.clusters
    SET server_count = (
        SELECT COUNT(*)
        FROM public.servers
        WHERE public.servers.cluster_id = NEW.cluster_id
    )
    WHERE cluster_id = NEW.cluster_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- Trigger to update server_count on changes in servers
CREATE TRIGGER update_server_count_trigger AFTER INSERT OR UPDATE OR DELETE ON public.servers
    FOR EACH ROW EXECUTE FUNCTION update_server_count();


-- Secrets view
CREATE VIEW public.v_secrets_list AS
SELECT
    s.project_id,
    s.secret_id,
    s.secret_name,
    s.secret_type,
    s.created_at,
    s.updated_at,
    CASE 
        WHEN COUNT(c.secret_id) > 0 OR COUNT(srv.secret_id) > 0 THEN true
        ELSE false
    END AS used,
    COALESCE(string_agg(DISTINCT c.cluster_name, ', '), '') AS used_by_clusters,
    COALESCE(string_agg(DISTINCT srv.server_name, ', '), '') AS used_by_servers
FROM
    public.secrets s
LEFT JOIN LATERAL (
    SELECT cluster_name, secret_id 
    FROM public.clusters 
    WHERE secret_id = s.secret_id AND project_id = s.project_id
) c ON true
LEFT JOIN LATERAL (
    SELECT srv.server_name, srv.secret_id 
    FROM public.servers srv
    JOIN public.clusters cl ON srv.cluster_id = cl.cluster_id
    WHERE srv.secret_id = s.secret_id AND cl.project_id = s.project_id
) srv ON true
GROUP BY
    s.project_id, s.secret_id, s.secret_name, s.secret_type, s.created_at, s.updated_at;


-- Extensions
CREATE TABLE public.extensions (
    extension_name text PRIMARY KEY,
    extension_description varchar(150) NOT NULL,
    extension_url text,
    extension_image text,
    postgres_min_version text,
    postgres_max_version text,
    contrib boolean NOT NULL
);

COMMENT ON TABLE public.extensions IS 'Table containing available extensions for different Postgres versions';
COMMENT ON COLUMN public.extensions.extension_name IS 'The name of the extension';
COMMENT ON COLUMN public.extensions.extension_description IS 'The description of the extension';
COMMENT ON COLUMN public.extensions.postgres_min_version IS 'The minimum Postgres version where the extension is available';
COMMENT ON COLUMN public.extensions.postgres_max_version IS 'The maximum Postgres version where the extension is available';
COMMENT ON COLUMN public.extensions.contrib IS 'Indicates if the extension is a contrib module or third-party extension';

-- The table stores information about Postgres extensions, including name, description, supported Postgres version range,
-- and whether the extension is a contrib module or third-party.
-- postgres_min_version and postgres_max_version define the range of Postgres versions supported by extensions.
-- If the postgres_max_version is NULL, it is assumed that the extension is still supported by new versions of Postgres.

INSERT INTO public.extensions (extension_name, extension_description, postgres_min_version, postgres_max_version, extension_url, extension_image, contrib) VALUES
    ('adminpack', 'administrative functions for PostgreSQL', NULL, NULL, NULL, NULL, true),
    ('amcheck', 'functions for verifying relation integrity', NULL, NULL, NULL, NULL, true),
    ('autoinc', 'functions for autoincrementing fields', NULL, NULL, NULL, NULL, true),
    ('bloom', 'bloom access method - signature file based index', NULL, NULL, NULL, NULL, true),
    ('btree_gin', 'support for indexing common datatypes in GIN', NULL, NULL, NULL, NULL, true),
    ('btree_gist', 'support for indexing common datatypes in GiST', NULL, NULL, NULL, NULL, true),
    ('chkpass', 'data type for auto-encrypted passwords', NULL, '10', NULL, NULL, true),
    ('citext', 'data type for case-insensitive character strings', NULL, NULL, NULL, NULL, true),
    ('cube', 'data type for multidimensional cubes', NULL, NULL, NULL, NULL, true),
    ('dblink', 'connect to other PostgreSQL databases from within a database', NULL, NULL, NULL, NULL, true),
    ('dict_int', 'text search dictionary template for integers', NULL, NULL, NULL, NULL, true),
    ('dict_xsyn', 'text search dictionary template for extended synonym processing', NULL, NULL, NULL, NULL, true),
    ('earthdistance', 'calculate great-circle distances on the surface of the Earth', NULL, NULL, NULL, NULL, true),
    ('file_fdw', 'foreign-data wrapper for flat file access', NULL, NULL, NULL, NULL, true),
    ('fuzzystrmatch', 'determine similarities and distance between strings', NULL, NULL, NULL, NULL, true),
    ('hstore', 'data type for storing sets of (key, value) pairs', NULL, NULL, NULL, NULL, true),
    ('insert_username', 'functions for tracking who changed a table', NULL, NULL, NULL, NULL, true),
    ('intagg', 'integer aggregator and enumerator (obsolete)', NULL, NULL, NULL, NULL, true),
    ('intarray', 'functions, operators, and index support for 1-D arrays of integers', NULL, NULL, NULL, NULL, true),
    ('isn', 'data types for international product numbering standards', NULL, NULL, NULL, NULL, true),
    ('lo', 'Large Object maintenance', NULL, NULL, NULL, NULL, true),
    ('ltree', 'data type for hierarchical tree-like structures', NULL, NULL, NULL, NULL, true),
    ('moddatetime', 'functions for tracking last modification time', NULL, NULL, NULL, NULL, true),
    ('old_snapshot', 'utilities in support of old_snapshot_threshold', '14', NULL, NULL, NULL, true),
    ('pageinspect', 'inspect the contents of database pages at a low level', NULL, NULL, NULL, NULL, true),
    ('pg_buffercache', 'examine the shared buffer cache', NULL, NULL, NULL, NULL, true),
    ('pg_freespacemap', 'examine the free space map (FSM)', NULL, NULL, NULL, NULL, true),
    ('pg_prewarm', 'prewarm relation data', NULL, NULL, NULL, NULL, true),
    ('pg_stat_statements', 'track planning and execution statistics of all SQL statements executed', NULL, NULL, NULL, NULL, true),
    ('pg_surgery', 'extension to perform surgery on a damaged relation', '14', NULL, NULL, NULL, true),
    ('pg_trgm', 'text similarity measurement and index searching based on trigrams', NULL, NULL, NULL, NULL, true),
    ('pg_visibility', 'examine the visibility map (VM) and page-level visibility info', NULL, NULL, NULL, NULL, true),
    ('pg_walinspect', 'functions to inspect contents of PostgreSQL Write-Ahead Log', '15', NULL, NULL, NULL, true),
    ('pgcrypto', 'cryptographic functions', NULL, NULL, NULL, NULL, true),
    ('pgrowlocks', 'show row-level locking information', NULL, NULL, NULL, NULL, true),
    ('pgstattuple', 'show tuple-level statistics', NULL, NULL, NULL, NULL, true),
    ('plpgsql', 'PL/pgSQL procedural language', NULL, NULL, NULL, NULL, true),
    ('postgres_fdw', 'foreign-data wrapper for remote PostgreSQL servers', NULL, NULL, NULL, NULL, true),
    ('refint', 'functions for implementing referential integrity (obsolete)', NULL, NULL, NULL, NULL, true),
    ('seg', 'data type for representing line segments or floating-point intervals', NULL, NULL, NULL, NULL, true),
    ('sslinfo', 'information about SSL certificates', NULL, NULL, NULL, NULL, true),
    ('tablefunc', 'functions that manipulate whole tables, including crosstab', NULL, NULL, NULL, NULL, true),
    ('tcn', 'Triggered change notifications', NULL, NULL, NULL, NULL, true),
    ('timetravel', 'functions for implementing time travel', NULL, '11', NULL, NULL, true),
    ('tsm_system_rows', 'TABLESAMPLE method which accepts number of rows as a limit', NULL, NULL, NULL, NULL, true),
    ('tsm_system_time', 'TABLESAMPLE method which accepts time in milliseconds as a limit', NULL, NULL, NULL, NULL, true),
    ('unaccent', 'text search dictionary that removes accents', NULL, NULL, NULL, NULL, true),
    ('uuid-ossp', 'generate universally unique identifiers (UUIDs)', NULL, NULL, NULL, NULL, true),
    ('xml2', 'XPath querying and XSLT', NULL, NULL, NULL, NULL, true),
    -- Third-Party Extensions
    ('citus', 'Citus is a PostgreSQL extension that transforms Postgres into a distributed database—so you can achieve high performance at any scale', 11, 16, 'https://github.com/citusdata/citus', 'citus.png', false),
    ('pgaudit', 'The PostgreSQL Audit Extension provides detailed session and/or object audit logging via the standard PostgreSQL logging facility', 10, 16, 'https://github.com/pgaudit/pgaudit', 'pgaudit.png', false),
    ('pg_cron', 'Job scheduler for PostgreSQL', 10, 16, 'https://github.com/citusdata/pg_cron', 'pg_cron.png', false),
    ('pg_partman', 'pg_partman is an extension to create and manage both time-based and number-based table partition sets', 10, 16, 'https://github.com/pgpartman/pg_partman', 'pg_partman.png', false),
    ('pg_repack', 'Reorganize tables in PostgreSQL databases with minimal locks', 10, 16, 'https://github.com/reorg/pg_repack', 'pg_repack.png', false),
    ('pg_stat_kcache', 'Gather statistics about physical disk access and CPU consumption done by backends', 10, 16, 'https://github.com/powa-team/pg_stat_kcache', NULL, false),
    ('pg_wait_sampling', 'Sampling based statistics of wait events', 10, 16, 'https://github.com/postgrespro/pg_wait_sampling', NULL, false),
    ('pgvector', 'Open-source vector similarity search for Postgres (vector data type and ivfflat and hnsw access methods)', 11, 16, 'https://github.com/pgvector/pgvector', 'pgvector.png', false),
    ('postgis', 'PostGIS extends the capabilities of the PostgreSQL relational database by adding support for storing, indexing, and querying geospatial data', 10, 16, 'https://postgis.net', 'postgis.png', false),
    ('pgrouting', 'pgRouting extends the PostGIS / PostgreSQL geospatial database to provide geospatial routing functionality', 10, 16, 'https://pgrouting.org', 'pgrouting.png', false),
    ('timescaledb', 'TimescaleDB is an open-source database designed to make SQL scalable for time-series data (Community Edition)', 12, 16, 'https://github.com/timescale/timescaledb', 'timescaledb.png', false);

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION get_extensions(p_postgres_version float, p_extension_type text DEFAULT 'all')
RETURNS json AS $$
DECLARE
    extensions json;
BEGIN
    SELECT json_agg(row_to_json(e))
    INTO extensions
    FROM (
        SELECT e.extension_name, e.extension_description, e.extension_url, e.extension_image, e.postgres_min_version, e.postgres_max_version, e.contrib
        FROM public.extensions e
        WHERE (e.postgres_min_version IS NULL OR e.postgres_min_version::float <= p_postgres_version)
          AND (e.postgres_max_version IS NULL OR e.postgres_max_version::float >= p_postgres_version)
          AND (p_extension_type = 'all' OR (p_extension_type = 'contrib' AND e.contrib = true) OR (p_extension_type = 'third_party' AND e.contrib = false))
        ORDER BY e.contrib, e.extension_image IS NULL, e.extension_name
    ) e;

    RETURN extensions;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- An example of using a function to get a list of available extensions (all or 'contrib'/'third_party' only)
-- SELECT get_extensions(16);
-- SELECT get_extensions(16, 'contrib');
-- SELECT get_extensions(16, 'third_party');


-- Operations
CREATE TABLE public.operations (
    id bigint NOT NULL,
    project_id bigint REFERENCES public.projects(project_id),
    cluster_id bigint REFERENCES public.clusters(cluster_id),
    operation_type text NOT NULL,
    operation_status text NOT NULL CHECK (operation_status IN ('in_progress', 'success', 'failed')),
    operation_log text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);

COMMENT ON TABLE public.operations IS 'Table containing logs of operations performed on clusters';
COMMENT ON COLUMN public.operations.id IS 'The ID of the operation from the backend';
COMMENT ON COLUMN public.clusters.project_id IS 'The ID of the project to which the operation belongs';
COMMENT ON COLUMN public.operations.cluster_id IS 'The ID of the cluster related to the operation';
COMMENT ON COLUMN public.operations.operation_type IS 'The type of operation performed (e.g., deploy, edit, update, restart, delete, etc.)';
COMMENT ON COLUMN public.operations.operation_status IS 'The status of the operation (in_progress, success, failed)';
COMMENT ON COLUMN public.operations.operation_log IS 'The log details of the operation';
COMMENT ON COLUMN public.operations.created_at IS 'The timestamp when the operation was created';
COMMENT ON COLUMN public.operations.updated_at IS 'The timestamp when the operation was last updated';

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.operations
    FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime (updated_at);

-- add created_at as part of the primary key to be able to create a hypertable
ALTER TABLE ONLY public.operations
    ADD CONSTRAINT operations_pkey PRIMARY KEY (created_at, id);

CREATE INDEX operations_project_id_idx ON public.operations (project_id);
CREATE INDEX operations_cluster_id_idx ON public.operations (cluster_id);
CREATE INDEX operations_project_cluster_id_idx ON public.operations (project_id, cluster_id, created_at);
CREATE INDEX operations_project_cluster_id_operation_type_idx ON public.operations (project_id, cluster_id, operation_type, created_at);

-- Check if the timescaledb extension is available and create hypertable if it is
-- +goose StatementBegin
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'timescaledb') THEN
        -- Convert the operations table to a hypertable
        PERFORM create_hypertable('public.operations', 'created_at', chunk_time_interval => interval '1 month');
        
        -- Check if the license allows compression policy
        IF current_setting('timescaledb.license', true) = 'timescale' THEN
            -- Enable compression on the operations hypertable, segmenting by project_id and cluster_id
            ALTER TABLE public.operations SET (
                timescaledb.compress,
                timescaledb.compress_orderby = 'created_at DESC, id DESC, operation_type, operation_status',
                timescaledb.compress_segmentby = 'project_id, cluster_id'
            );
            -- Compressing chunks older than one month
            PERFORM add_compression_policy('public.operations', interval '1 month');
        ELSE
            RAISE NOTICE 'Timescaledb license does not support compression policy. Skipping compression setup.';
        END IF;
    ELSE
        RAISE NOTICE 'Timescaledb extension is not available. Skipping hypertable and compression setup.';
    END IF;
END
$$;
-- +goose StatementEnd

CREATE OR REPLACE VIEW public.v_operations AS
SELECT 
    op.project_id,
    op.cluster_id,
    op.id,
    op.created_at AS "started",
    op.updated_at AS "finished",
    op.operation_type AS "type",
    op.operation_status AS "status",
    cl.cluster_name AS "cluster",
    env.environment_name AS "environment",
    op.operation_log AS "log"
FROM 
    public.operations op
JOIN 
    public.clusters cl ON op.cluster_id = cl.cluster_id
JOIN 
    public.projects pr ON op.project_id = pr.project_id
JOIN 
    public.environments env ON cl.environment_id = env.environment_id;


-- +goose Down

-- Drop triggers
DROP TRIGGER update_server_count_trigger ON public.servers;
DROP TRIGGER handle_updated_at ON public.servers;
DROP TRIGGER handle_updated_at ON public.clusters;
DROP TRIGGER handle_updated_at ON public.environments;
DROP TRIGGER handle_updated_at ON public.projects;
DROP TRIGGER handle_updated_at ON public.secrets;
DROP TRIGGER handle_updated_at ON public.cloud_images;
DROP TRIGGER handle_updated_at ON public.cloud_volumes;
DROP TRIGGER handle_updated_at ON public.cloud_instances;
DROP TRIGGER handle_updated_at ON public.operations;

-- Drop functions
DROP FUNCTION update_server_count;
DROP FUNCTION get_extensions;
DROP FUNCTION get_secret;
DROP FUNCTION add_secret;

-- Drop views
DROP VIEW public.v_operations;
DROP VIEW public.v_secrets_list;

-- Drop tables
DROP TABLE public.operations;
DROP TABLE public.extensions;
DROP TABLE public.servers;
DROP TABLE public.clusters;
DROP TABLE public.secrets;
DROP TABLE public.environments;
DROP TABLE public.projects;
DROP TABLE public.cloud_images;
DROP TABLE public.cloud_volumes;
DROP TABLE public.cloud_instances;
DROP TABLE public.cloud_regions;
DROP TABLE public.cloud_providers;
