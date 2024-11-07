'use client';

import { CalendarDateRangePicker } from '@/components/date-range-picker';
import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { fDate } from '@/lib/format-time';
import { useGetAllPaymentHistoriesQuery } from '@/store/queries/paymentManagement';
import { useState } from 'react';
import { columns } from './columns';

const STATUS_OPTIONS = [
  { value: 'pending', label: 'Pending' },
  { value: 'completed', label: 'Completed' },
  { value: 'failed', label: 'Failed' }
];

export default function PaymentTable() {
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [sortField, setSortField] = useState<string | null>(null);
  const [sortDirection, setSortDirection] = useState<string | null>(null);
  const [status, setStatus] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [startDate, setStartDate] = useState('1-1-2024');
  const [endDate, setEndDate] = useState(fDate(Date.now()));

  const {
    result = [],
    meta = { total: 0, page: 1, take: 10, totalPages: 1 },
    isFetching
  } = useGetAllPaymentHistoriesQuery(
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

  const handleSortChange = (
    field: string | null,
    direction: 'asc' | 'desc' | null
  ) => {
    if (field && direction) {
      setSortField(field);
      setSortDirection(direction);
      setPage(1);
    } else {
      setSortField('createdAt');
      setSortDirection('desc');
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
