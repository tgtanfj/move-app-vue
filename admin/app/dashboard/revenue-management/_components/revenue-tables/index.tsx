'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Revenue } from '@/constants/data';
import { useGetRevenueEachUserQuery } from '@/store/queries/paymentManagement';
import { useState } from 'react';
import { columns } from './columns';

export default function RevenueTable() {
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [sortField, setSortField] = useState<string | null>(null);
  const [sortDirection, setSortDirection] = useState<string | null>(null);
  const [search, setSearch] = useState('');

  const {
    result = [],
    meta = { total: 0, page: 1, take: 10, totalPages: 1 },
    isFetching
  } = useGetRevenueEachUserQuery(
    {
      take: pageSize,
      page,
      search,
      sortField,
      sortDirection
    },
    {
      selectFromResult: ({ data, isFetching }) => ({
        result: data?.data || [],
        meta: data?.meta || {
          total: 0,
          page: 1,
          take: pageSize,
          totalPages: 1
        },
        isFetching
      })
    }
  );

  const handleSortChange = (
    field: string | null,
    direction: 'asc' | 'desc' | null
  ) => {
    if (field && direction) {
      setSortField(field);
      setSortDirection(direction);
      setPage(1);
    } else {
      setSortField('id');
      setSortDirection('asc');
      setPage(1);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center gap-4">
        <DataTableSearch
          searchQuery={search}
          setSearchQuery={setSearch}
          setPage={setPage}
          searchKey={'full name or email'}
        />

        <DataTableResetFilter
          isFilterActive={search ? true : false}
          onReset={() => {
            setSearch('');
            setPage(1);
            setPageSize(10);
          }}
        />
      </div>
      <DataTable
        columns={columns}
        data={result}
        meta={meta}
        pageSizeOptions={[10, 20, 50]}
        onPageChange={(page) => setPage(page)}
        onPageSizeChange={(size) => setPageSize(size)}
        onSortChange={handleSortChange}
      />
    </div>
  );
}

// ----------------------------------------------------------------------

function applyFilter({
  inputData,
  filterName
}: {
  inputData: Revenue[];
  filterName: string;
}) {
  const stabilizedThis = inputData.map((el, index) => [el, index] as const);

  inputData = stabilizedThis.map((el) => el[0]);

  if (filterName) {
    inputData = inputData.filter(
      (revenue) =>
        revenue.fullName.toLowerCase().indexOf(filterName.toLowerCase()) !==
          -1 ||
        revenue.email.toLowerCase().indexOf(filterName.toLowerCase()) !== -1
    );
  }

  return inputData;
}
