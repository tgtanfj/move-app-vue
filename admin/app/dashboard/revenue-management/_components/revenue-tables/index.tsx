'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Revenue } from '@/constants/data';
import { columns } from './columns';
import { useWithdrawTableFilters } from './use-revenue-table-filters';

export default function RevenueTable({
  data = [],
  totalData
}: {
  data: Revenue[];
  totalData: number;
}) {
  const {
    isAnyFilterActive,
    resetFilters,
    searchQuery,
    setPage,
    setSearchQuery
  } = useWithdrawTableFilters();

  const dataFiltered = applyFilter({
    inputData: data,
    filterName: searchQuery
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
