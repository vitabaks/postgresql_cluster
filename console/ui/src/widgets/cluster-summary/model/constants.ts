import { PROVIDERS } from '@shared/config/constants.ts';
import AWSIcon from '@widgets/cluster-summary/assets/awsIcon.svg';
import GCPIcon from '@widgets/cluster-summary/assets/gcpIcon.svg';
import AzureIcon from '@widgets/cluster-summary/assets/azureIcon.svg';
import DigitalOceanIcon from '@widgets/cluster-summary/assets/digitaloceanIcon.svg';
import HetznerIcon from '@widgets/cluster-summary/assets/hetznerIcon2.svg';

export const providerNamePricingListMap = Object.freeze({
  [PROVIDERS.AWS]: 'https://aws.amazon.com/ec2/pricing/on-demand/',
  [PROVIDERS.GCP]: 'https://cloud.google.com/compute/vm-instance-pricing/#general-purpose_machine_type_family',
  [PROVIDERS.AZURE]: 'https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/',
  [PROVIDERS.DIGITAL_OCEAN]: 'https://www.digitalocean.com/pricing/droplets/',
  [PROVIDERS.HETZNER]: 'https://www.hetzner.com/cloud/',
});

export const clusterSummaryNameIconProvidersMap = Object.freeze({
  [PROVIDERS.AWS]: AWSIcon,
  [PROVIDERS.GCP]: GCPIcon,
  [PROVIDERS.AZURE]: AzureIcon,
  [PROVIDERS.DIGITAL_OCEAN]: DigitalOceanIcon,
  [PROVIDERS.HETZNER]: HetznerIcon,
});
