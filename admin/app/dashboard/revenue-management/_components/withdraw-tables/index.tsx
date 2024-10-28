'use client';

import { CalendarDateRangePicker } from '@/components/date-range-picker';
import { DataTable } from '@/components/ui/table/data-table';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Withdraw } from '@/constants/data';
import { fTimestamp } from '@/lib/format-time';
import { useState } from 'react';
import { DateRange } from 'react-day-picker';
import { columns } from './columns';
import { useWithdrawTableFilters } from './use-withdraw-table-filters';

export default function WithdrawTable({
  data = [],
  totalData
}: {
  data: Withdraw[];
  totalData: number;
}) {
  const {
    isAnyFilterActive,
    resetFilters,
    searchQuery,
    setPage,
    setSearchQuery
  } = useWithdrawTableFilters();

  const [selectedDateRange, setSelectedDateRange] = useState<DateRange | null>(
    null
  );

  const dataFiltered = applyFilter({
    inputData: data,
    filterName: searchQuery,
    filterStartDate: selectedDateRange?.from,
    filterEndDate: selectedDateRange?.to
  });

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center gap-4">
        <DataTableSearch
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          setPage={setPage}
          searchKey={'full name or email'}
        />
        <CalendarDateRangePicker
          onChange={(range) => setSelectedDateRange(range)}
        />

        <DataTableResetFilter
          isFilterActive={isAnyFilterActive}
          onReset={resetFilters}
        />
      </div>
      <DataTable columns={columns} data={dataFiltered} totalItems={totalData} />
    </div>
  );
}

// ----------------------------------------------------------------------

function applyFilter({
  inputData,
  filterName,
  filterStartDate,
  filterEndDate
}: {
  inputData: Withdraw[];
  filterName: string;
  filterStartDate: Date | undefined;
  filterEndDate: Date | undefined;
}) {
  const stabilizedThis = inputData.map((el, index) => [el, index] as const);

  inputData = stabilizedThis.map((el) => el[0]);

  if (filterName) {
    inputData = inputData.filter(
      (withdraw) =>
        withdraw.channel.name
          .toLowerCase()
          .indexOf(filterName.toLowerCase()) !== -1 ||
        withdraw.channel.user.email
          .toLowerCase()
          .indexOf(filterName.toLowerCase()) !== -1 ||
        withdraw.channel.user.fullName
          .toLowerCase()
          .indexOf(filterName.toLowerCase()) !== -1
    );
  }

  if (filterStartDate && filterEndDate) {
    inputData = inputData.filter(
      (withdraw) =>
        fTimestamp(withdraw.createdAt) >= fTimestamp(filterStartDate) &&
        fTimestamp(withdraw.createdAt) <= fTimestamp(filterEndDate)
    );
  }

  return inputData;
}
