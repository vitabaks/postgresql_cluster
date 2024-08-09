import { FC } from 'react';
import { Box, Slider, TextField, Typography } from '@mui/material';
import { SliderBoxProps } from '@shared/ui/slider-box/model/types.ts';

import { generateSliderMarks } from '@shared/ui/slider-box/lib/functions.ts';

const ClusterSliderBox: FC<SliderBoxProps> = ({
  amount,
  changeAmount,
  unit,
  icon,
  min = 1,
  max,
  marks,
  marksAmount,
  marksAdditionalLabel = '',
  step,
  error,
  limitMin = true,
  limitMax,
}) => {
  const onChange = (e) => {
    const { value } = e.target;

    if (/^\d*$/.test(value)) changeAmount(value < min && limitMin ? min : value > max && limitMax ? max : value);
  };

  return (
    <Box display="flex" border="1px solid #E0E0E0" height="100px">
      <Box
        display="flex"
        alignItems="center"
        justifyContent="center"
        borderRight="1px solid #E0E0E0"
        width="200px"
        height="100px"
        padding="8px"
        boxSizing="border-box"
        gap="8px">
        {icon}
        <TextField
          required
          value={amount}
          onChange={onChange}
          error={!!error}
          helperText={error?.message ?? ''}
          size="small"
          sx={{ width: '100px' }}
        />
        <Typography>{unit}</Typography>
      </Box>
      <Box display="flex" alignItems="center" justifyContent="center" width="100%" padding="32px">
        <Slider
          value={amount}
          onChange={changeAmount}
          step={step}
          valueLabelDisplay="auto"
          min={min}
          max={max}
          marks={marks ?? generateSliderMarks(min ?? 1, max ?? 100, marksAmount ?? 0, marksAdditionalLabel)}
        />
      </Box>
    </Box>
  );
};

export default ClusterSliderBox;
