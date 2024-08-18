import { FC, useEffect, useState } from 'react';
import { Box } from '@mui/material';
import { useGetOperationsByIdLogQuery } from '@shared/api/api/operations.ts';
import { useParams } from 'react-router-dom';
import { LazyLog } from 'react-lazylog';
import { useQueryPolling } from '@shared/lib/hooks.tsx';
import { OPERATION_LOGS_POLLING_INTERVAL } from '@shared/config/constants.ts';

const OperationLog: FC = () => {
  const { operationId } = useParams();
  const [isStopRequest, setIsStopRequest] = useState(false);

  const log = useQueryPolling(
    () => useGetOperationsByIdLogQuery({ id: operationId }),
    OPERATION_LOGS_POLLING_INTERVAL,
    { stop: isStopRequest },
  );

  useEffect(() => {
    setIsStopRequest(!!log.data?.isComplete);
  }, [log.data?.isComplete]);

  return (
    <Box width="100%" height="85vh">
      <LazyLog
        follow
        scrollToAlignment="end"
        text={log.data?.log ?? '\t'}
        extraLines={1}
        overscanRowCount={10}
        caseInsensitive
        selectableLines
        enableSearch
      />
    </Box>
  );
};

export default OperationLog;
