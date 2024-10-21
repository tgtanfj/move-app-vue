"use client";
import * as React from "react";
import { AppRouterCacheProvider } from "@mui/material-nextjs/v14-appRouter";
import { ThemeProvider } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";
import theme from "@/utils/theme";
import AuthLayout from "@/components/core/layouts/AuthLayout";
import Providers from "@/provider";

export default function RootLayout(props: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <AuthLayout>{props.children}</AuthLayout>
      </body>
    </html>
  );
}
