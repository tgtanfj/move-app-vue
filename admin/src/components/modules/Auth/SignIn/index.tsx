import CustomTextField from "@/components/core/common/ThemeElements/CustomTextField";
import { useSignInMutation } from "@/store/queries/auth";
import {
  Box,
  Button,
  Checkbox,
  FormControl,
  FormControlLabel,
  FormGroup,
  Link,
  Snackbar,
  Stack,
  Typography,
} from "@mui/material";
import { useRouter } from "next-nprogress-bar";
import React, { useState } from "react";

function SignInModule() {
  const router = useRouter();
  const [signIn, { isLoading }] = useSignInMutation();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [openSnackbar, setOpenSnackbar] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState("");

  const handleSnackbarClose = () => {
    setOpenSnackbar(false);
  };

  const handleSignIn = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    try {
      await signIn({ email, password }).unwrap();
      setSnackbarMessage("Sign-in successful!");
      setOpenSnackbar(true);
      router.push("/admin/dashboard");
    } catch (error: any) {
      setSnackbarMessage(error?.data?.message || "Sign-in failed!");
      setOpenSnackbar(true);
    }
  };

  return (
    <>
      <form onSubmit={handleSignIn}>
        <Stack>
          <Box>
            <FormControl fullWidth>
              <Typography
                variant="subtitle1"
                fontWeight={600}
                component="label"
                htmlFor="email"
                mb="5px"
              >
                Email
              </Typography>
              <CustomTextField
                variant="outlined"
                fullWidth
                value={email}
                onChange={(e: any) => setEmail(e.target.value)}
              />
            </FormControl>
          </Box>
          <Box mt="25px">
            <FormControl fullWidth>
              <Typography
                variant="subtitle1"
                fontWeight={600}
                component="label"
                htmlFor="password"
                mb="5px"
              >
                Password
              </Typography>
              <CustomTextField
                type="password"
                variant="outlined"
                fullWidth
                value={password}
                onChange={(e: any) => setPassword(e.target.value)}
              />
            </FormControl>
          </Box>
          <Stack
            justifyContent="space-between"
            direction="row"
            alignItems="center"
            my={2}
          >
            <FormGroup>
              <FormControlLabel
                control={<Checkbox defaultChecked />}
                label="Remember this Device"
              />
            </FormGroup>
            <Typography
              component={Link}
              href="/"
              fontWeight="500"
              sx={{
                textDecoration: "none",
                color: "primary.main",
              }}
            >
              Forgot Password?
            </Typography>
          </Stack>
        </Stack>
        <Box>
          <Button
            color="primary"
            variant="contained"
            size="large"
            fullWidth
            type="submit"
            disabled={isLoading}
          >
            {isLoading ? "Signing In..." : "Sign In"}
          </Button>
        </Box>
      </form>

      <Snackbar
        open={openSnackbar}
        autoHideDuration={6000}
        onClose={handleSnackbarClose}
        message={snackbarMessage}
        anchorOrigin={{ vertical: "top", horizontal: "center" }}
      />
    </>
  );
}

export default SignInModule;
