'use client';
import PageContainer from '@/components/layout/page-container';
import { Separator } from '@/components/ui/separator';
import PaymentTable from './revenue-tables';

export default function RevenueListingPage({}) {
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Separator />
        <PaymentTable />
      </div>
    </PageContainer>
  );
}
