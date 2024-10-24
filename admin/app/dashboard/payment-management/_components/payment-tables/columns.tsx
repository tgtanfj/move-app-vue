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
    accessorKey: 'user.fullName',
    header: 'Full Name'
  },
  {
    accessorKey: 'user.email',
    header: 'Email'
  },
  {
    accessorKey: 'createdAt',
    header: 'Created At',
    cell: ({ getValue }) => (
      <span>{new Date(getValue() as string).toUTCString()}</span>
    )
  },
  {
    accessorKey: 'repsPackage.numberOfREPs',
    header: 'REPs'
  },
  {
    accessorKey: 'repsPackage.price',
    header: 'Amount ($)'
  }
];
