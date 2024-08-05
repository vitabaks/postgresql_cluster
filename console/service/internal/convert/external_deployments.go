package convert

import (
	"postgresql-cluster-console/internal/storage"
	"postgresql-cluster-console/models"
	"sort"

	"github.com/go-openapi/strfmt"
	"go.openly.dev/pointy"
)

func ProviderInfoToSwagger(providerInfo *storage.CloudProviderInfo, description, image string) *models.ResponseDeploymentInfo {
	resp := &models.ResponseDeploymentInfo{
		AvatarURL:     image,
		CloudRegions:  nil,
		Code:          providerInfo.Code,
		Description:   description,
		Volumes:       nil,
		InstanceTypes: &models.ResponseDeploymentInfoInstanceTypes{},
	}

	cloudRegions := make(map[string][]*models.DeploymentInfoCloudRegionDatacentersItems0)
	for _, cloudRegion := range providerInfo.CloudRegions {
		datacenterRegion := &models.DeploymentInfoCloudRegionDatacentersItems0{
			Code:     cloudRegion.RegionName,
			Location: cloudRegion.Description,
		}
		cloudImage := findCloudImage(providerInfo.CloudImages, cloudRegion.RegionName)
		if cloudImage == nil {
			cloudImage = findCloudImage(providerInfo.CloudImages, "all")
		}
		if cloudImage != nil {
			datacenterRegion.CloudImage = &models.DeploymentCloudImage{
				Arch:      cloudImage.Arch,
				Image:     cloudImage.Image,
				OsName:    cloudImage.OsName,
				OsVersion: cloudImage.OsVersion,
				UpdatedAt: strfmt.DateTime(cloudImage.UpdatedAt),
			}
		}
		cloudRegions[cloudRegion.RegionGroup] = append(cloudRegions[cloudRegion.RegionGroup], datacenterRegion)
	}

	mapKeys := make([]string, 0, len(cloudRegions))
	for k, _ := range cloudRegions {
		mapKeys = append(mapKeys, k)
	}
	sort.Strings(mapKeys)

	for _, k := range mapKeys {
		resp.CloudRegions = append(resp.CloudRegions, &models.DeploymentInfoCloudRegion{
			Code:        k,
			Datacenters: cloudRegions[k],
			Name:        k,
		})
	}

	for _, instance := range providerInfo.CloudInstances {
		switch instance.InstanceGroup {
		case storage.InstanceTypeSmall:
			resp.InstanceTypes.Small = append(resp.InstanceTypes.Small, &models.DeploymentInstanceType{
				Code:         instance.InstanceName,
				CPU:          instance.Cpu,
				PriceHourly:  instance.PriceHourly,
				PriceMonthly: instance.PriceMonthly,
				Currency:     instance.Currency,
				RAM:          instance.Ram,
			})
		case storage.InstanceTypeMedium:
			resp.InstanceTypes.Medium = append(resp.InstanceTypes.Medium, &models.DeploymentInstanceType{
				Code:         instance.InstanceName,
				CPU:          instance.Cpu,
				PriceHourly:  instance.PriceHourly,
				PriceMonthly: instance.PriceMonthly,
				Currency:     instance.Currency,
				RAM:          instance.Ram,
			})
		case storage.InstanceTypeLarge:
			resp.InstanceTypes.Large = append(resp.InstanceTypes.Large, &models.DeploymentInstanceType{
				Code:         instance.InstanceName,
				CPU:          instance.Cpu,
				PriceHourly:  instance.PriceHourly,
				PriceMonthly: instance.PriceMonthly,
				Currency:     instance.Currency,
				RAM:          instance.Ram,
			})
		}
	}

	for _, cloudVolume := range providerInfo.CloudVolumes {
		resp.Volumes = append(resp.Volumes, &models.ResponseDeploymentInfoVolumesItems0{
			Currency:          cloudVolume.Currency,
			MaxSize:           cloudVolume.VolumeMaxSize,
			MinSize:           cloudVolume.VolumeMinSize,
			PriceMonthly:      cloudVolume.PriceMonthly,
			VolumeDescription: cloudVolume.VolumeDescription,
			VolumeType:        cloudVolume.VolumeType,
			IsDefault:         pointy.Bool(cloudVolume.IsDefault),
		})
	}

	return resp
}

func findCloudImage(images []storage.CloudImage, regionName string) *storage.CloudImage {
	for i, image := range images {
		if image.Region == regionName {
			return &images[i]
		}
	}

	return nil
}
