'use client';
import { Video } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';
import Image from 'next/image';

export const columns: ColumnDef<Video>[] = [
  {
    accessorKey: 'id',
    header: 'ID'
  },
  {
    accessorKey: 'title',
    header: 'TITLE'
  },
  {
    accessorKey: 'createdAt',
    header: 'Uploaded At',
    cell: ({ getValue }) => (
      <span>{new Date(getValue() as string).toLocaleDateString()}</span>
    )
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
    header: 'DURATION',
    enableSorting: false
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
  }
];
