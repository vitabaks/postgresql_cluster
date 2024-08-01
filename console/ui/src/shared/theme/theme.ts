import { createTheme } from '@mui/material';
import { blue } from '@mui/material/colors';
import { enUS } from '@mui/material/locale';

declare module '@mui/material/styles' {
  interface PaletteColor {
    lighter10?: string;
  }

  interface SimplePaletteColorOptions {
    lighter10?: string;
  }
}

const theme = createTheme(
  {
    palette: {
      primary: {
        main: blue[800],
        lighter10: '#0D8CE91A',
      },
    },
    components: {
      MuiAppBar: {
        styleOverrides: {
          colorPrimary: {
            backgroundColor: '#F6F8FA',
          },
        },
      },
    },
  },
  enUS,
);

export default theme;
