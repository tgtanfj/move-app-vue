import { searchParamsCache } from '@/lib/searchparams';
import { SearchParams } from 'nuqs/parsers';
import React from 'react';
import PaymentListingPage from './_components/paymment-listing-page';

type pageProps = {
  searchParams: SearchParams;
};

export const metadata = {
  title: 'Dashboard : Payment Management'
};

export default async function Page({ searchParams }: pageProps) {
  searchParamsCache.parse(searchParams);

  return <PaymentListingPage />;
}
