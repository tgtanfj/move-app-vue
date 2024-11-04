'use client';
import PageContainer from '@/components/layout/page-container';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import VideoTable from './video-tables';
import { useGetAllVideosQuery } from '@/store/queries/videoManagement';
import { useState } from 'react';
import { useVideoTableFilters } from './video-tables/use-video-table-filters';

export default function VideoListingPage() {
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  const { searchQuery, workoutLevelFilter, setPage } = useVideoTableFilters();

  const {
    result: videosData = [],
    meta = { total: 0, page: currentPage, take: pageSize, totalPages: 1 },
    isFetching
  } = useGetAllVideosQuery(
    {
      page: currentPage,
      take: pageSize,
      query: searchQuery,
      workoutLevel: workoutLevelFilter,
      sortBy: ''
    },
    {
      selectFromResult: ({ data, isFetching }) => ({
        result: data?.data || [],
        meta: data?.meta || {
          total: 0,
          page: currentPage,
          take: pageSize,
          totalPages: 1
        },
        isFetching
      }),
      refetchOnMountOrArgChange: true
    }
  );

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    setPage(page);
  };

  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <div className="flex items-start justify-between">
          <Heading
            title={`Videos (${meta.total})`}
            description="Manage videos"
          />
        </div>
        <Separator />
        <VideoTable
          key={`${currentPage}-${pageSize}`}
          data={videosData}
          totalData={meta.total}
          currentPage={currentPage}
          pageSize={pageSize}
          totalPages={meta.totalPages}
          isLoading={isFetching}
          onPageChange={handlePageChange}
          onPageSizeChange={setPageSize}
        />
      </div>
    </PageContainer>
  );
}
