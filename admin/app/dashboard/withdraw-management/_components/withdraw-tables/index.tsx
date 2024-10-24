'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Withdraw } from '@/constants/data';
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

  const filteredData = data.filter((withdraw) => {
    const matchesSearchName = withdraw.channel.user.fullName
      .toLowerCase()
      .includes(searchQuery.toLowerCase());

    const matchesSearchEmail = withdraw.channel.user.email
      .toLowerCase()
      .includes(searchQuery.toLowerCase());

    const matchesSearchChannel = withdraw.channel.name
      .toLowerCase()
      .includes(searchQuery.toLowerCase());

    return matchesSearchName || matchesSearchEmail || matchesSearchChannel;
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
      <DataTable columns={columns} data={filteredData} totalItems={totalData} />
    </div>
  );
}
