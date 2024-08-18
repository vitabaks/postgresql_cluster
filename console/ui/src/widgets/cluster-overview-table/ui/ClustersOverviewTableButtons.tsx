import { FC } from 'react';
import { Button, Stack } from '@mui/material';
import RefreshIcon from '@mui/icons-material/Refresh';
import { useTranslation } from 'react-i18next';
import { usePostClustersByIdRefreshMutation } from '@shared/api/api/clusters.ts';
import { useParams } from 'react-router-dom';

const ClustersOverviewTableButtons: FC = () => {
  const { t } = useTranslation('shared');
  const { clusterId } = useParams();

  const [refreshClusterTrigger] = usePostClustersByIdRefreshMutation();

  const handleRefresh = async () => {
    await refreshClusterTrigger({ id: Number(clusterId) });
  };

  return (
    <Stack direction="row" justifyContent="flex-end" gap="8px">
      <Button onClick={handleRefresh} startIcon={<RefreshIcon />} variant="text">
        {t('refresh')}
      </Button>
    </Stack>
  );
};

export default ClustersOverviewTableButtons;
