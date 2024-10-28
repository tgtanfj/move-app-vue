'use client';
import { Withdraw } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';

export const columns: ColumnDef<Withdraw>[] = [
  {
    accessorKey: 'id',
    header: 'Withdraw ID',
    enableSorting: false,
    size: 500
  },
  {
    accessorKey: 'channel.user.fullName',
    header: 'Full Name'
  },
  {
    accessorKey: 'channel.user.email',
    header: 'Email'
  },

  {
    accessorKey: 'channel.name',
    header: 'Channel'
  },
  {
    accessorKey: 'createdAt',
    header: 'Created At',
    cell: ({ getValue }) => (
      <span>{new Date(getValue() as string).toUTCString()}</span>
    )
  },
  {
    accessorKey: 'numberOfREPs',
    header: 'REPs'
  }
];
