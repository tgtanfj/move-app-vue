'use client';

import { CalendarDateRangePicker } from '@/components/date-range-picker';
import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { fDate } from '@/lib/format-time';
import { useGetAllWithdrawHistoriesQuery } from '@/store/queries/paymentManagement';
import { useState } from 'react';
import { columns } from './columns';
import { STATUS_OPTIONS } from './use-withdraw-table-filters';

export default function WithdrawTable() {
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [sortField, setSortField] = useState('createdAt');
  const [sortDirection, setSortDirection] = useState<'asc' | 'desc'>('asc');
  const [status, setStatus] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [startDate, setStartDate] = useState('1-1-2024');
  const [endDate, setEndDate] = useState(fDate(Date.now()));

  const {
    result = [],
    meta = { total: 0, page: 1, take: 10, totalPages: 1 },
    isFetching
  } = useGetAllWithdrawHistoriesQuery(
    {
      startDate,
      endDate,
      take: pageSize,
      page,
      status,
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

  const handleSortChange = (field: string, direction: 'asc' | 'desc') => {
    setSortField(field);
    setSortDirection(direction);
    setPage(1); // Reset to the first page when sorting changes
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
        <DataTableFilterBox
          filterKey="status"
          title="Status"
          options={STATUS_OPTIONS}
          setFilterValue={setStatus}
          filterValue={status || ''}
        />
        <CalendarDateRangePicker
          onChange={(range) => {
            if (range && typeof range !== 'object') return;
            if (range && 'from' in range && 'to' in range) {
              setStartDate(range?.from?.toLocaleDateString() || '');
              setEndDate(range?.to?.toLocaleDateString() || '');
            }
          }}
        />

        <DataTableResetFilter
          isFilterActive={search || status ? true : false}
          onReset={() => {
            setStatus('');
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
