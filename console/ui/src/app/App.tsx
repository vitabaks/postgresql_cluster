import { FC } from 'react';
import { ThemeProvider } from '@mui/material';
import theme from '@shared/theme/theme.ts';
import Router from '@app/router/Router.tsx';
import { Provider } from 'react-redux';
import { ToastContainer } from 'react-toastify';
import { LocalizationProvider } from '@mui/x-date-pickers';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFnsV3';
import { store } from '@app/redux/store/store.ts';

const App: FC = () => {
  return (
    <Provider store={store}>
      <ThemeProvider theme={theme}>
        <LocalizationProvider dateAdapter={AdapterDateFns}>
          <Router />
          <ToastContainer />
        </LocalizationProvider>
      </ThemeProvider>
    </Provider>
  );
};

export default App;
