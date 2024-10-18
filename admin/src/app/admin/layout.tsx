"use client";
import { AppProvider, DashboardLayout, Navigation } from "@toolpad/core";
import AdminNavigation from "@/components/modules/Navigation/Navigation";
import theme from "@/utils/theme";
export default function RootAdminLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
  params: { locale: string };
}>) {
  const NAVIGATION = AdminNavigation(); // Gọi component để lấy navigation

  return (
    <AppProvider
      theme={theme}
      navigation={NAVIGATION}
      branding={{
        logo: <img src="/images/logo.svg" alt="MUI logo" />,
        title: "",
      }}
    >
      <DashboardLayout>{children}</DashboardLayout>
    </AppProvider>
  );
}
