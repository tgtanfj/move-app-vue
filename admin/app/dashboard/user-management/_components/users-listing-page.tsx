'use client';
import PageContainer from '@/components/layout/page-container';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import { useGetAllUsersQuery } from '@/store/queries/usersManagement';
import { useState } from 'react';
import UsersTable from './user-tables';
import { useUserTableFilters } from './user-tables/use-user-table-filters';

export default function UsersListingPage() {
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  const { searchQuery, genderFilter, setPage } = useUserTableFilters();

  const {
    result: usersData = [],
    meta = { total: 0, page: currentPage, take: pageSize, totalPages: 1 },
    isFetching
  } = useGetAllUsersQuery(
    {
      page: currentPage,
      take: pageSize,
      contentSearch: searchQuery,
      gender: genderFilter,
      sortBy: '',
      isAsc: true
    },
    {
      selectFromResult: ({ data, isFetching }) => ({
        result: data?.data || [],
        meta: data?.meta || {
          total: 0,
          page: currentPage,
          take: pageSize,
          totalPages: 1
        },
        isFetching
      })
    }
  );

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    setPage(page); // Sync with filter state
  };

  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <div className="flex items-start justify-between">
          <Heading
            title={`Users (${meta.total})`}
            description="Manage users in your organization"
          />
        </div>
        <Separator />
        <UsersTable
          key={`${currentPage}-${pageSize}`} // Change key to re-render UsersTable
          data={usersData}
          totalData={meta.total}
          currentPage={currentPage}
          pageSize={pageSize}
          totalPages={meta.totalPages}
          isLoading={isFetching}
          onPageChange={handlePageChange}
          onPageSizeChange={setPageSize}
        />
      </div>
    </PageContainer>
  );
}
