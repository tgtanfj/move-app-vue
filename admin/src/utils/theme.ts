import { createTheme } from "@mui/material/styles";
import { red } from "@mui/material/colors";

// Create a theme instance.
const theme = createTheme({
  palette: {
    primary: {
      main: "#13D0B4",
    },
    secondary: {
      main: "#fffff",
    },
    error: {
      main: "#FF647A",
    },
  },
});

export default theme;
