'use client';
import PageContainer from '@/components/layout/page-container';
import { Separator } from '@/components/ui/separator';
import { useState } from 'react';
import VideoTable from './video-tables';
import { useVideoTableFilters } from './video-tables/use-video-table-filters';

export default function VideoListingPage() {
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  const { searchQuery, workoutLevelFilter, setPage } = useVideoTableFilters();

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    setPage(page);
  };

  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Separator />
        <VideoTable />
      </div>
    </PageContainer>
  );
}
