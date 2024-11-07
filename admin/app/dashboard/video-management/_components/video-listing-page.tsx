'use client';
import PageContainer from '@/components/layout/page-container';
import { Separator } from '@/components/ui/separator';
import VideoTable from './video-tables';

export default function VideoListingPage() {
  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <Separator />
        <VideoTable />
      </div>
    </PageContainer>
  );
}
