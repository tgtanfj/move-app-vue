'use client';
import PageContainer from '@/components/layout/page-container';
import { Separator } from '@/components/ui/separator';
import UsersTable from './user-tables';

export default function UsersListingPage() {
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Separator />
        <UsersTable />
      </div>
    </PageContainer>
  );
}
