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
    cell: ({ getValue }) => {
      const numberOfREPs = getValue() as number;
      const amount = (numberOfREPs * 0.006).toFixed(2); // Format the amount to 2 decimal places
      return numberOfREPs ? (
        <div>
          <span>{numberOfREPs} REPs</span>
          <br /> {/* Line break for the second line */}
          <span>{amount} $</span>
        </div>
      ) : (
        0
      );
    },
    enableSorting: true
  },
  {
    accessorKey: 'totalTopUp',
    header: 'Top up',
    cell: ({ getValue }) => {
      const numberOfREPs = getValue() as number;
      const amount = (numberOfREPs * 0.007).toFixed(2); // Format the amount to 2 decimal places
      return numberOfREPs ? (
        <div>
          <span>{numberOfREPs} REPs</span>
          <br /> {/* Line break for the second line */}
          <span>{amount} $</span>
        </div>
      ) : (
        0
      );
    },
    enableSorting: true
  },
  {
    accessorKey: 'totalDonations',
    header: 'Donations (REPs)',
    cell: ({ getValue }) => {
      const numberOfREPs = getValue() as number;
      return numberOfREPs ? <span>{numberOfREPs} REPs</span> : 0;
    },

    enableSorting: true
  }
];
