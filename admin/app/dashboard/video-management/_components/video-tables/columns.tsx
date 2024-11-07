'use client';
import { Checkbox } from '@/components/ui/checkbox';
import { Video } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';
import Image from 'next/image';
import { CellAction } from './cell-action';

export const columns: ColumnDef<Video>[] = [
  {
    id: 'select',
    header: ({ table }) => (
      <Checkbox
        checked={table.getIsAllPageRowsSelected()}
        onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
        aria-label="Select all"
      />
    ),
    cell: ({ row }) => (
      <Checkbox
        checked={row.getIsSelected()}
        onCheckedChange={(value) => row.toggleSelected(!!value)}
        aria-label="Select row"
      />
    ),
    enableSorting: false,
    enableHiding: false
  },
  {
    accessorKey: 'title',
    header: 'TITLE'
  },
  {
    accessorKey: 'thumbnail',
    header: 'THUMBNAIL',
    enableSorting: false,
    cell: ({ row }) => {
      console.log(row);
      return (
        <div className="relative aspect-square h-16 w-16">
          <Image
            src={row.original.thumbnails[0].image}
            alt={row.getValue('title')}
            fill
          />
        </div>
      );
    }
  },
  {
    accessorKey: 'workoutLevel',
    header: 'WORKOUT LEVEL',
    enableSorting: false
  },
  {
    accessorKey: 'duration',
    header: 'DURATION'
  },
  {
    accessorKey: 'numberOfViews',
    header: 'VIEWS'
  },
  {
    accessorKey: 'numberOfComments',
    header: 'COMMENTS'
  },
  {
    accessorKey: 'ratings',
    header: 'RATINGS'
  },
  {
    id: 'actions',
    cell: ({ row }) => <CellAction data={row.original} />
  }
];
