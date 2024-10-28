'use client';
import PageContainer from '@/components/layout/page-container';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import {
  useGetBalanceQuery,
  useGetRevenueEachUserQuery,
  useGetTotalRevenueQuery,
  useGetTotalWithdrawQuery
} from '@/store/queries/paymentManagement';
import PaymentTable from './revenue-tables';

export default function RevenueListingPage({}) {
  const {
    result = [],
    total = 0,
    isFetching,
    refetch
  } = useGetRevenueEachUserQuery(null, {
    selectFromResult: ({ data, isFetching }) => ({
      result: data?.data || [],
      total: data?.data?.length ?? 0,
      isFetching
    })
  });

  const { balanceAvailable = 0, balancePending = 0 } = useGetBalanceQuery(
    null,
    {
      selectFromResult: ({ data, isFetching }) => ({
        balanceAvailable: data?.data.available[0].amount ?? 0,
        balancePending: data?.data?.pending[0].amount ?? 0,
        isFetching
      })
    }
  );

  const { totalRevenue = 0 } = useGetTotalRevenueQuery(null, {
    selectFromResult: ({ data }) => ({
      totalRevenue: data?.data.totalRevenue ?? 0
    })
  });

  const { totalWithdraw = 0 } = useGetTotalWithdrawQuery(null, {
    selectFromResult: ({ data }) => ({
      totalWithdraw: data?.data.totalWithdraw ?? 0
    })
  });

  return (
    <PageContainer scrollable>
      <div className="space-y-4">
        <div className="flex items-start justify-between">
          <Heading
            title={`Revenues (${total})`}
            description="Manage revenue in your organization"
          />
        </div>
        <Separator />
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">
                Total Revenue
              </CardTitle>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                className="h-4 w-4 text-muted-foreground"
              >
                <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
              </svg>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                $ {balanceAvailable / 100}
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Pending</CardTitle>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                className="h-4 w-4 text-muted-foreground"
              >
                <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
              </svg>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">$ {balancePending / 100}</div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Revenue</CardTitle>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                className="h-4 w-4 text-muted-foreground"
              >
                <rect width="20" height="14" x="2" y="5" rx="2" />
                <path d="M2 10h20" />
              </svg>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">$ {totalRevenue / 100}</div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Withdrawal</CardTitle>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                className="h-4 w-4 text-muted-foreground"
              >
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                <circle cx="9" cy="7" r="4" />
                <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
              </svg>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                $ {Number(totalWithdraw).toFixed(2)}
              </div>
            </CardContent>
          </Card>
        </div>
        <PaymentTable data={result} totalData={total} />
      </div>
    </PageContainer>
  );
}
