import { ReactNode } from 'react';

export interface InfoCardBodyProps {
  config: {
    title: string;
    children: ReactNode;
  }[];
}
