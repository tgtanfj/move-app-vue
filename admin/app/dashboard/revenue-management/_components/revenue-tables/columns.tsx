'use client';
import { Revenue } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';

export const columns: ColumnDef<Revenue>[] = [
  {
    accessorKey: 'id',
    header: 'User ID',
    enableSorting: false
  },
  {
    accessorKey: 'fullName',
    header: 'Full Name'
  },
  {
    accessorKey: 'email',
    header: 'Email'
  },
  {
    accessorKey: 'totalEarnings',
    header: 'Earning'
  },
  {
    accessorKey: 'totalTopUp',
    header: 'Top up'
  },
  {
    accessorKey: 'totalDonations',
    header: 'Donations'
  }
];
