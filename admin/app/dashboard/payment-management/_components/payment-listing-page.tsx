'use client';
import PageContainer from '@/components/layout/page-container';
import { Separator } from '@/components/ui/separator';
import PaymentTable from './payment-tables';

export default function PaymentListingPage() {
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Separator />
        <PaymentTable />
      </div>
    </PageContainer>
  );
}
