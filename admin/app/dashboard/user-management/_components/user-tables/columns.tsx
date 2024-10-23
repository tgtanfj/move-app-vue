'use client';
import { Employee } from '@/constants/data';
import { ColumnDef } from '@tanstack/react-table';

export const columns: ColumnDef<Employee>[] = [
  {
    accessorKey: 'id',
    header: 'User ID',
    enableSorting: false
  },
  {
    accessorKey: 'username',
    header: 'User Name'
  },
  {
    accessorKey: 'email',
    header: 'Email'
  },
  {
    accessorKey: 'fullName',
    header: 'Full Name'
  },
  {
    accessorKey: 'gender',
    header: 'Gender'
  },
  {
    accessorKey: 'dateOfBirth',
    header: 'Date of Birth',
    cell: ({ getValue }) => (
      <span>{new Date(getValue() as string).toLocaleDateString()}</span>
    )
  },
  {
    accessorKey: 'country.name',
    header: 'Country'
  },
  {
    accessorKey: 'state.name',
    header: 'State'
  },
  {
    accessorKey: 'city',
    header: 'City'
  }
];
