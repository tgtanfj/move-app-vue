'use client';

import { Button } from '@/components/ui/button';
import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { useGetAllUsersQuery } from '@/store/queries/usersManagement';
import Papa from 'papaparse';
import { useState } from 'react';
import * as XLSX from 'xlsx';
import { columns } from './columns';
import { GENDER_OPTIONS } from './use-user-table-filters';

export default function UsersTable() {
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [gender, setGender] = useState<string | null>(null);
  const [search, setSearch] = useState('');

  const [sortBy, setSortBy] = useState<string | null>(null);
  const [isAsc, setIsAsc] = useState<boolean | undefined>(undefined);

  const {
    result = [],
    meta = { total: 0, page: page, take: pageSize, totalPages: 1 },
    isFetching
  } = useGetAllUsersQuery(
    {
      page: page,
      take: pageSize,
      contentSearch: search,
      gender: gender,
      sortBy: sortBy,
      isAsc: isAsc
    },
    {
      selectFromResult: ({ data, isFetching }) => ({
        result: data?.data || [],
        meta: data?.meta || {
          total: 0,
          page: page,
          take: pageSize,
          totalPages: 1
        },
        isFetching
      })
    }
  );

  // Export data to CSV
  const exportToCSV = () => {
    const csv = Papa.unparse(result);
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', 'users_data.csv');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // Export data to Excel
  const exportToExcel = () => {
    const worksheet = XLSX.utils.json_to_sheet(result);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Users Data');
    XLSX.writeFile(workbook, 'users_data.xlsx');
  };

  return (
    <div className="space-y-4">
      {false ? (
        <div className="flex items-center justify-center">
          <span>Loading...</span>
        </div>
      ) : (
        <>
          <div className="flex flex-wrap items-center gap-4">
            <DataTableSearch
              searchQuery={search}
              setSearchQuery={setSearch}
              setPage={setPage}
              searchKey={'email or username'}
            />
            <DataTableFilterBox
              filterKey="gender"
              title="Gender"
              options={GENDER_OPTIONS}
              setFilterValue={setGender}
              filterValue={gender || ''}
            />
            <DataTableResetFilter
              isFilterActive={search || gender ? true : false}
              onReset={() => {
                setGender(null);
                setSearch('');
                setPage(1);
                setPageSize(10);
              }}
            />
            <Button
              onClick={exportToCSV}
              className="rounded bg-blue-500 px-4 py-2 text-white"
            >
              Export to CSV
            </Button>
            <Button
              onClick={exportToExcel}
              className="rounded bg-green-500 px-4 py-2 text-white"
            >
              Export to Excel
            </Button>
          </div>
          <DataTable
            columns={columns}
            data={result}
            meta={meta}
            pageSizeOptions={[10, 20, 50]}
            onPageChange={(page) => setPage(page)}
            onPageSizeChange={(size) => setPageSize(size)}
            onSortChange={(field, direction) => {
              console.log(field, direction);
              if (field && direction) {
                setSortBy(field);
                setIsAsc(direction === 'asc');
                setPage(1);
              } else {
                setSortBy('id');
                setIsAsc(direction === 'asc');
                setPage(1);
              }
            }}
          />
        </>
      )}
    </div>
  );
}
