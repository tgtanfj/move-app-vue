'use client';

import { store } from '@/store';
import { AppProgressBar } from 'next-nprogress-bar';
import { ThemeProvider as NextThemesProvider } from 'next-themes';
import { ThemeProviderProps } from 'next-themes/dist/types';
import { useRouter } from 'next/navigation';
import * as React from 'react';
import { Provider } from 'react-redux';
import { Toaster } from 'sonner';

export interface ProvidersProps {
  children: React.ReactNode;
  themeProps?: ThemeProviderProps;
}

export function Providers({ children, themeProps }: ProvidersProps) {
  const router = useRouter();

  return (
    <React.Suspense>
      <NextThemesProvider {...themeProps}>
        <AppProgressBar
          shallowRouting
          color="#13D0B4"
          height="4px"
          options={{ showSpinner: false }}
        />
        <Provider store={store}>
          <Toaster richColors position="top-right" />
          {children},
        </Provider>
      </NextThemesProvider>
    </React.Suspense>
  );
}
