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
    header: 'Full Name',
    enableSorting: false
  },
  {
    accessorKey: 'email',
    header: 'Email',
    enableSorting: false
  },
  {
    accessorKey: 'totalEarnings',
    header: 'Earning (REPs)',
    enableSorting: true
  },
  {
    accessorKey: 'totalTopUp',
    header: 'Top up (REPs)',
    enableSorting: true
  },
  {
    accessorKey: 'totalDonations',
    header: 'Donations (REPs)',
    enableSorting: true
  }
];
