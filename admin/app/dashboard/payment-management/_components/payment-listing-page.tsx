'use client';
import PageContainer from '@/components/layout/page-container';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { useGetAllPaymentHistoriesQuery } from '@/store/queries/paymentManagement';
import PaymentTable from './payment-tables';

export default function PaymentListingPage({}) {
  const {
    result = [],
    total = 0,
    isFetching,
    refetch
  } = useGetAllPaymentHistoriesQuery(null, {
    selectFromResult: ({ data, isFetching }) => ({
      result: data?.data || [],
      total: data?.data?.length ?? 0,
      isFetching
    })
  });

  console.log(result);

  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <div className="flex items-start justify-between">
          <Heading
            title={`Payments (${total})`}
            description="Manage payment histories in your organization"
          />
        </div>
        <Separator />
        <PaymentTable data={result} totalData={total} />
      </div>
    </PageContainer>
  );
}
