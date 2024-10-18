import React from "react";
import { TextField } from "@mui/material";

interface SearchProps {
  label: string;
  placeholder: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
}

const Search: React.FC<SearchProps> = ({
  label,
  placeholder,
  value,
  onChange,
}) => {
  return (
    <TextField
      label={label}
      placeholder={placeholder}
      variant="outlined"
      fullWidth
      margin="normal"
      value={value}
      onChange={onChange}
    />
  );
};

export default Search;
