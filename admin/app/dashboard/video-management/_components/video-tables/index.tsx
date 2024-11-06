'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { columns } from '../video-tables/columns';
import {
  WORKOUT_LEVEL_OPTIONS,
  useVideoTableFilters
} from './use-video-table-filters';
import { Video } from '@/constants/data';
import { useMemo } from 'react';

export default function VideoTable({
  data = [],
  totalData,
  currentPage,
  pageSize,
  totalPages,
  isLoading,
  onPageChange,
  onPageSizeChange
}: {
  data: Video[];
  totalData: number;
  currentPage: number;
  pageSize: number;
  totalPages: number;
  isLoading: boolean;
  onPageChange: (page: number) => void;
  onPageSizeChange: (size: number) => void;
}) {
  const {
    workoutLevelFilter,
    setWorkoutLevelFilter,
    isAnyFilterActive,
    resetFilters,
    searchQuery,
    setPage,
    setSearchQuery
  } = useVideoTableFilters();

  // Apply filtering logic
  const filteredData = useMemo(() => {
    return data.filter((video) => {
      const matchesSearch = searchQuery
        ? video.title.toLowerCase().includes(searchQuery.toLowerCase())
        : true;
      const matchesWorkoutLevel = workoutLevelFilter
        ? video.workoutLevel === workoutLevelFilter
        : true;
      return matchesSearch && matchesWorkoutLevel;
    });
  }, [data, searchQuery, workoutLevelFilter]);

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
              searchKey="title"
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
              setPage={setPage}
            />
            <DataTableFilterBox
              filterKey="workoutLevel"
              title="Workout Level"
              options={WORKOUT_LEVEL_OPTIONS}
              setFilterValue={setWorkoutLevelFilter}
              filterValue={workoutLevelFilter}
            />
            <DataTableResetFilter
              isFilterActive={isAnyFilterActive}
              onReset={resetFilters}
            />
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
