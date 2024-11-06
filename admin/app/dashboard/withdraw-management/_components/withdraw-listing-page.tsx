'use client';
import PageContainer from '@/components/layout/page-container';
import { Separator } from '@/components/ui/separator';
import PaymentTable from './withdraw-tables';

type TUsersListingPage = {};

export default function WithdrawListingPage() {

  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Separator />
        <PaymentTable />
      </div>
    </PageContainer>
  );
}
