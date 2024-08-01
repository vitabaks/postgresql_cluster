import { FC } from 'react';
import { Box } from '@mui/material';
import ClustersTable from '@widgets/clusters-table';

const Clusters: FC = () => {
  return (
    <Box>
      <ClustersTable />
    </Box>
  );
};

export default Clusters;
