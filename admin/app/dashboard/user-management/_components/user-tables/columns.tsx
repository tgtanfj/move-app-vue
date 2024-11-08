'use client';
import { Employee } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';

export const columns: ColumnDef<Employee>[] = [
  {
    accessorKey: 'id',
    header: 'User ID'
  },
  {
    accessorKey: 'username',
    header: 'User Name',
    enableSorting: false
  },
  {
    accessorKey: 'email',
    header: 'Email',
    enableSorting: true
  },
  {
    accessorKey: 'fullName',
    header: 'Full Name',
    enableSorting: false
  },
  {
    accessorKey: 'gender',
    header: 'Gender',
    enableSorting: false
  },
  {
    accessorKey: 'dateOfBirth',
    header: 'Date of Birth',
    cell: ({ getValue }) => (
      <span>{new Date(getValue() as string).toLocaleDateString()}</span>
    ),
    enableSorting: false
  },
  {
    accessorKey: 'country.name',
    header: 'Country',
    enableSorting: false
  },
  {
    accessorKey: 'state.name',
    header: 'State',
    enableSorting: false
  },
  {
    accessorKey: 'city',
    header: 'City',
    enableSorting: false
  }
];
