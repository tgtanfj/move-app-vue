'use client';
import { Payment } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';

export const columns: ColumnDef<Payment>[] = [
  {
    accessorKey: 'id',
    header: 'Payment ID',
    enableSorting: false
  },
  {
    accessorKey: 'fullName',
    header: 'Full Name',
    enableSorting: false
  },
  {
    accessorKey: 'email',
    header: 'Email',
    enableSorting: false
  },
  {
    accessorKey: 'createdAt',
    header: 'Created At',
    cell: ({ getValue }) => (
      <span>{new Date(getValue() as string).toUTCString()}</span>
    ),
    enableSorting: true
  },
  {
    accessorKey: 'numberOfREPs',
    header: 'REPs',
    enableSorting: true
  },
  {
    accessorKey: 'price',
    header: 'Amount ($)',
    enableSorting: true
  }
];
