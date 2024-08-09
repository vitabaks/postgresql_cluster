import { GenerateMarkType, GenerateSliderMarksType } from '@shared/ui/slider-box/model/types.ts';

const generateMark: GenerateMarkType = (value, marksAdditionalLabel) => ({
  value,
  label: `${value} ${marksAdditionalLabel}`,
});

export const generateSliderMarks: GenerateSliderMarksType = (min, max, amount, marksAdditionalLabel) => {
  const step = (max - min) / (amount - 1);
  const marksArray = [];

  for (let i = min; i < max + step; i += step) {
    marksArray.push(generateMark(Math.trunc(i), marksAdditionalLabel));
  }

  return marksArray;
};
