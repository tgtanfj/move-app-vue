'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Payment } from '@/constants/data';
import { columns } from './columns';
import { usePaymentTableFilters } from './use-payment-table-filters';

export default function PaymentTable({
  data = [],
  totalData
}: {
  data: Payment[];
  totalData: number;
}) {
  const {
    isAnyFilterActive,
    resetFilters,
    searchQuery,
    setPage,
    setSearchQuery
  } = usePaymentTableFilters();

  const filteredData = data.filter((payment) => {
    const matchesSearchName = payment.user.fullName
      .toLowerCase()
      .includes(searchQuery.toLowerCase());

    const matchesSearchEmail = payment.user.email
      .toLowerCase()
      .includes(searchQuery.toLowerCase());

    return matchesSearchName || matchesSearchEmail;
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
