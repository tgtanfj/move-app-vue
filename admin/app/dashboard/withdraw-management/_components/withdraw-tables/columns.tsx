'use client';
import { Withdraw } from '@/constants/data';
import { toSentenceCase } from '@/utils/toSentenceCase';
import { ColumnDef } from '@tanstack/react-table';

export const columns: ColumnDef<Withdraw>[] = [
  {
    accessorKey: 'id',
    header: 'Withdraw ID',
    enableSorting: false
  },
  {
    accessorKey: 'channel.user.fullName',
    header: 'Full Name',
    enableSorting: false
  },
  {
    accessorKey: 'channel.user.email',
    header: 'Email',
    enableSorting: false
  },
  {
    accessorKey: 'channel.name',
    header: 'Channel',
    enableSorting: false
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ getValue }) => <span>{toSentenceCase(getValue() as string)}</span>,
    enableSorting: false
  },
  {
    accessorKey: 'numberOfREPs',
    header: 'Amounts',
    cell: ({ getValue }) => {
      const numberOfREPs = getValue() as number;
      const amount = (numberOfREPs * 0.006).toFixed(2); // Format the amount to 2 decimal places
      return (
        <div>
          <span>{numberOfREPs} REPs</span>
          <br /> {/* Line break for the second line */}
          <span>{amount} $</span>
        </div>
      );
    },
    enableSorting: true
  },
  {
    accessorKey: 'createdAt',
    header: 'Created At',
    cell: ({ getValue }) => (
      <span>{new Date(getValue() as string).toUTCString()}</span>
    ),
    enableSorting: true
  }
];
