import FAQTable from "@/components/modules/FAQs";
import { Table } from "@mui/material";
import { Metadata } from "next";
import React from "react";

export const metadata: Metadata = {
  title: "MOVE | FAQS",
};

function FAQS() {
  return (
    <div>
      <FAQTable />
    </div>
  );
}

export default FAQS;
