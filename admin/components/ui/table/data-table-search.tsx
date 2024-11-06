'use client';

import { Input } from '@/components/ui/input';
import { cn } from '@/lib/utils';
import { useTransition } from 'react';

interface DataTableSearchProps {
  searchKey: string;
  searchQuery: string;
  setSearchQuery: (value: string | ((old: string) => string)) => void;
  setPage: (value: number | ((old: number) => number)) => void;
}

export function DataTableSearch({
  searchKey,
  searchQuery,
  setSearchQuery,
  setPage
}: DataTableSearchProps) {
  const [isLoading, startTransition] = useTransition();

  const handleSearch = (value: string) => {
    // Wrap `setSearchQuery` in `startTransition` if needed
    startTransition(() => {
      setSearchQuery(value);
      setPage(1); // Reset page when search query changes
    });
  };

  return (
    <Input
      placeholder={`Search ${searchKey}...`}
      value={searchQuery ?? ''}
      onChange={(e) => handleSearch(e.target.value)}
      className={cn('w-full md:max-w-sm', isLoading && 'animate-pulse')}
    />
  );
}
