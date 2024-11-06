'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Employee } from '@/constants/data';
import { columns } from './columns';
import { GENDER_OPTIONS, useUserTableFilters } from './use-user-table-filters';
import Papa from 'papaparse';
import * as XLSX from 'xlsx';
import { Button } from '@/components/ui/button';
import { useMemo } from 'react';

export default function UsersTable({
  data = [],
  totalData,
  currentPage,
  pageSize,
  totalPages,
  isLoading,
  onPageChange,
  onPageSizeChange
}: {
  data: Employee[];
  totalData: number;
  currentPage: number;
  pageSize: number;
  totalPages: number;
  isLoading: boolean;
  onPageChange: (page: number) => void;
  onPageSizeChange: (size: number) => void;
}) {
  const {
    genderFilter,
    setGenderFilter,
    isAnyFilterActive,
    resetFilters,
    searchQuery,
    setPage,
    setSearchQuery
  } = useUserTableFilters();

  // Apply filtering logic
  const filteredData = useMemo(() => {
    return data.filter((employee) => {
      const matchesSearch = searchQuery
        ? employee.email.toLowerCase().includes(searchQuery.toLowerCase())
        : true;
      const matchesGender = genderFilter
        ? employee.gender === genderFilter
        : true;
      return matchesSearch && matchesGender;
    });
  }, [data, searchQuery, genderFilter]);

  // Export data to CSV
  const exportToCSV = () => {
    const csv = Papa.unparse(filteredData);
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
    const worksheet = XLSX.utils.json_to_sheet(filteredData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Users Data');
    XLSX.writeFile(workbook, 'users_data.xlsx');
  };

  // Handle pagination change
  const handlePaginationChange = (newPage: number, newSize: number) => {
    onPageChange(newPage);
    onPageSizeChange(newSize);
  };

  return (
    <div className="space-y-4">
      {isLoading ? (
        <div className="flex items-center justify-center">
          <span>Loading...</span>
        </div>
      ) : (
        <>
          <div className="flex flex-wrap items-center gap-4">
            <DataTableSearch
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
              setPage={setPage}
              searchKey={'email or username'}
            />
            <DataTableFilterBox
              filterKey="gender"
              title="Gender"
              options={GENDER_OPTIONS}
              setFilterValue={setGenderFilter}
              filterValue={genderFilter}
            />
            <DataTableResetFilter
              isFilterActive={isAnyFilterActive}
              onReset={resetFilters}
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
            data={filteredData}
            totalItems={totalData}
            pageSizeOptions={[10, 20, 50]}
            onPageChange={(page) => handlePaginationChange(page, pageSize)}
            onPageSizeChange={(size) =>
              handlePaginationChange(currentPage, size)
            }
          />
        </>
      )}
    </div>
  );
}
