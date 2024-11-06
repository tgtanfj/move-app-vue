'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { useGetAllVideosQuery } from '@/store/queries/videoManagement';
import { useState } from 'react';
import { columns } from '../video-tables/columns';
import { WORKOUT_LEVEL_OPTIONS } from './use-video-table-filters';

export default function VideoTable() {
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [search, setSearch] = useState('');

  const [sortBy, setSortBy] = useState<string | null>(null);
  const [sortType, setSortType] = useState<string>('ASC');

  const [workoutLevelFilter, setWorkoutLevelFilter] = useState<string | null>(
    null
  );

  const {
    result = [],
    meta = { total: 0, page: page, take: pageSize, totalPages: 1 },
    isFetching
  } = useGetAllVideosQuery(
    {
      page: page,
      take: pageSize,
      query: search,
      workoutLevel: workoutLevelFilter,
      sortBy: sortBy,
      sortType: sortType
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
      }),
      refetchOnMountOrArgChange: true
    }
  );

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
              searchKey="title"
              searchQuery={search}
              setSearchQuery={setSearch}
              setPage={setPage}
            />
            <DataTableFilterBox
              filterKey="workoutLevel"
              title="Workout Level"
              options={WORKOUT_LEVEL_OPTIONS}
              setFilterValue={setWorkoutLevelFilter}
              filterValue={workoutLevelFilter || ''}
            />
            <DataTableResetFilter
              isFilterActive={search || workoutLevelFilter ? true : false}
              onReset={() => {
                setWorkoutLevelFilter(null);
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
            onSortChange={(field, direction) => {
              console.log(field, direction);
              if (field && direction) {
                setSortBy(field);
                setSortType(direction === 'asc' ? 'ASC' : 'DESC');
                setPage(1);
              } else {
                setSortBy('title');
                setSortType('ASC');
                setPage(1);
              }
            }}
          />
        </>
      )}
    </div>
  );
}
