"use client";
import React, { useState } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination,
  TextField,
  Select,
  MenuItem,
  InputLabel,
  FormControl,
  TableSortLabel,
  Paper,
  Button,
  Modal,
  Box,
  Typography,
  IconButton,
  Checkbox,
} from "@mui/material";
import { Edit, Delete } from "@mui/icons-material";

export interface FAQ {
  id: number;
  question: string;
  category: string;
  date: string;
}

const initialData: FAQ[] = [
  { id: 1, question: "What is MOVE?", category: "General", date: "2023-01-15" },
  {
    id: 2,
    question: "How to use MOVE?",
    category: "Usage",
    date: "2023-02-20",
  },
  {
    id: 3,
    question: "What are the features?",
    category: "General",
    date: "2023-03-10",
  },
  {
    id: 4,
    question: "How to contact support?",
    category: "Support",
    date: "2023-04-25",
  },
];

type Order = "asc" | "desc";

function FAQTable() {
  const [data, setData] = useState<FAQ[]>(initialData);
  const [filteredData, setFilteredData] = useState<FAQ[]>(initialData);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);
  const [order, setOrder] = useState<Order>("asc");
  const [orderBy, setOrderBy] = useState<keyof FAQ>("question");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [newQuestion, setNewQuestion] = useState("");
  const [newCategory, setNewCategory] = useState("");
  const [selectedFAQ, setSelectedFAQ] = useState<FAQ | null>(null);

  const handleOpenModal = (faq?: FAQ) => {
    setIsEditing(!!faq);
    setSelectedFAQ(faq || null);
    setNewQuestion(faq?.question || "");
    setNewCategory(faq?.category || "");
    setIsModalOpen(true);
  };

  const handleCloseModal = () => setIsModalOpen(false);

  const handleAddOrUpdateFAQ = () => {
    if (isEditing && selectedFAQ) {
      const updatedData = data.map((faq) =>
        faq.id === selectedFAQ.id
          ? { ...faq, question: newQuestion, category: newCategory }
          : faq
      );
      setData(updatedData);
      setFilteredData(updatedData);
    } else {
      const newFAQ: FAQ = {
        id: data.length + 1,
        question: newQuestion,
        category: newCategory,
        date: new Date().toISOString().split("T")[0],
      };
      const newData = [...data, newFAQ];
      setData(newData);
      setFilteredData(newData);
    }
    handleCloseModal();
  };

  const handleDelete = (id: number) => {
    const updatedData = data.filter((faq) => faq.id !== id);
    setData(updatedData);
    setFilteredData(updatedData);
  };

  const handleChangePage = (event: unknown, newPage: number) =>
    setPage(newPage);

  const handleChangeRowsPerPage = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const createSortHandler = (property: keyof FAQ) => () => {
    const isAsc = orderBy === property && order === "asc";
    setOrder(isAsc ? "desc" : "asc");
    setOrderBy(property);

    const sortedData = [...filteredData].sort((a, b) => {
      const compare =
        a[property] < b[property] ? -1 : a[property] > b[property] ? 1 : 0;
      return isAsc ? compare : -compare;
    });

    setFilteredData(sortedData);
  };

  return (
    <Paper sx={{ width: "100%", overflow: "hidden", padding: 2 }}>
      <Button
        color="primary"
        variant="contained"
        onClick={() => handleOpenModal()}
        sx={{ mb: 2 }}
      >
        Add FAQ
      </Button>
      <TableContainer>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>
                <Checkbox
                  color="primary"
                  inputProps={{ "aria-label": "select all FAQs" }}
                />
              </TableCell>
              <TableCell sortDirection={orderBy === "question" ? order : false}>
                <TableSortLabel
                  active={orderBy === "question"}
                  direction={orderBy === "question" ? order : "asc"}
                  onClick={createSortHandler("question")}
                >
                  Question
                </TableSortLabel>
              </TableCell>
              <TableCell>Category</TableCell>
              <TableCell>Date</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredData
              .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
              .map((row) => (
                <TableRow key={row.id}>
                  <TableCell padding="checkbox">
                    <Checkbox color="primary" />
                  </TableCell>
                  <TableCell>{row.question}</TableCell>
                  <TableCell>{row.category}</TableCell>
                  <TableCell>{row.date}</TableCell>
                  <TableCell>
                    <IconButton onClick={() => handleOpenModal(row)}>
                      <Edit />
                    </IconButton>
                    <IconButton onClick={() => handleDelete(row.id)}>
                      <Delete />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))}
          </TableBody>
        </Table>
      </TableContainer>
      <TablePagination
        component="div"
        count={filteredData.length}
        page={page}
        onPageChange={handleChangePage}
        rowsPerPage={rowsPerPage}
        onRowsPerPageChange={handleChangeRowsPerPage}
      />
      <Modal open={isModalOpen} onClose={handleCloseModal}>
        <Box
          sx={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            width: 400,
            bgcolor: "background.paper",
            boxShadow: 24,
            p: 4,
            borderRadius: 2,
          }}
        >
          <Typography variant="h6" component="h2" sx={{ mb: 2 }}>
            {isEditing ? "Edit FAQ" : "Add New FAQ"}
          </Typography>
          <TextField
            label="Question"
            fullWidth
            margin="normal"
            value={newQuestion}
            onChange={(e) => setNewQuestion(e.target.value)}
          />
          <FormControl fullWidth margin="normal">
            <InputLabel>Category</InputLabel>
            <Select
              value={newCategory}
              onChange={(e) => setNewCategory(e.target.value)}
            >
              <MenuItem value="General">General</MenuItem>
              <MenuItem value="Usage">Usage</MenuItem>
              <MenuItem value="Support">Support</MenuItem>
            </Select>
          </FormControl>
          <Button
            variant="contained"
            onClick={handleAddOrUpdateFAQ}
            sx={{ mt: 2 }}
            fullWidth
          >
            {isEditing ? "Update FAQ" : "Add FAQ"}
          </Button>
        </Box>
      </Modal>
    </Paper>
  );
}

export default FAQTable;
