// components/AdminNavigation.tsx

import React from "react";
import DashboardIcon from "@mui/icons-material/Dashboard";
import OndemandVideoIcon from "@mui/icons-material/OndemandVideo";
import PaymentsIcon from "@mui/icons-material/Payments";
import DescriptionIcon from "@mui/icons-material/Description";
import PersonIcon from "@mui/icons-material/Person";
import FileCopyIcon from "@mui/icons-material/FileCopy";
import { Navigation } from "@toolpad/core";

const NAVIGATION: Navigation = [
  {
    kind: "header",
    title: "Main items",
  },
  {
    segment: "dashboard",
    title: "Dashboard",
    icon: <DashboardIcon />,
  },
  {
    segment: "video-management",
    title: "Video management",
    icon: <OndemandVideoIcon />,
  },
  {
    kind: "divider",
  },
  {
    kind: "header",
    title: "Other",
  },
  {
    segment: "user-management",
    title: "User management",
    icon: <PersonIcon />,
  },
  {
    segment: "payment-management ",
    title: "Payment management ",
    icon: <PaymentsIcon />,
    children: [
      {
        segment: "sales",
        title: "Sales",
        icon: <DescriptionIcon />,
      },
      {
        segment: "traffic",
        title: "Traffic",
        icon: <DescriptionIcon />,
      },
    ],
  },
  {
    segment: "admin/faqs",
    title: "Content management ",
    icon: <FileCopyIcon />,
  },
];

const AdminNavigation = () => NAVIGATION;

export default AdminNavigation;
