'use client';
import PageContainer from '@/components/layout/page-container';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { useGetAllUsersQuery } from '@/store/queries/usersManagement';
import UsersTable from './user-tables';

type TUsersListingPage = {};

export default function UsersListingPage({}: TUsersListingPage) {
  const {
    result = [],
    total = 0,
    isFetching,
    refetch
  } = useGetAllUsersQuery(null, {
    selectFromResult: ({ data, isFetching }) => ({
      result: data?.data || [],
      total: data?.data?.length ?? 0,
      isFetching
    })
  });

  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <div className="flex items-start justify-between">
          <Heading
            title={`Users (${total})`}
            description="Manage users in your organization"
          />
        </div>
        <Separator />
        <UsersTable data={result} totalData={total} />
      </div>
    </PageContainer>
  );
}
