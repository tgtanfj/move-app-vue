"use client";

import React, { useState } from "react";
import AppBar from "@mui/material/AppBar";
import Toolbar from "@mui/material/Toolbar";
import IconButton from "@mui/material/IconButton";
import Badge from "@mui/material/Badge";
import Avatar from "@mui/material/Avatar";
import Menu from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
import Typography from "@mui/material/Typography";
import Tooltip from "@mui/material/Tooltip";
import Switch from "@mui/material/Switch";
import { Box, Button, Popover } from "@mui/material";
import SettingsIcon from "@mui/icons-material/Settings";
import NotificationsIcon from "@mui/icons-material/Notifications";
import MenuIcon from "@mui/icons-material/Menu";

export default function Header() {
  const [anchorElUser, setAnchorElUser] = useState(null);
  const [anchorElNotification, setAnchorElNotification] = useState(null);

  const handleOpenUserMenu = (event: any) => {
    setAnchorElUser(event.currentTarget);
  };

  const handleCloseUserMenu = () => {
    setAnchorElUser(null);
  };

  const handleOpenNotification = (event: any) => {
    setAnchorElNotification(event.currentTarget);
  };

  const handleCloseNotification = () => {
    setAnchorElNotification(null);
  };

  const handleLogout = () => {
    // Logic logout here
    console.log("Logout");
  };

  return (
    <AppBar position="static" sx={{ backgroundColor: "#fff", color: "#000" }}>
      <Toolbar>
        {/* Sidebar Toggle */}
        <IconButton
          edge="start"
          color="inherit"
          aria-label="menu"
          onClick={() => console.log("Toggle Sidebar")}
        >
          <MenuIcon />
        </IconButton>

        {/* Right Section */}
        <Box sx={{ flexGrow: 1 }} />

        {/* Theme Switch */}
        <Switch defaultChecked />

        {/* Settings */}
        <Tooltip title="Settings">
          <IconButton sx={{ ml: 2 }} color="inherit">
            <SettingsIcon />
          </IconButton>
        </Tooltip>

        {/* Notifications */}
        <IconButton color="inherit" onClick={handleOpenNotification}>
          <Badge badgeContent={5} color="error">
            <NotificationsIcon />
          </Badge>
        </IconButton>
        <Popover
          open={Boolean(anchorElNotification)}
          anchorEl={anchorElNotification}
          onClose={handleCloseNotification}
          anchorOrigin={{
            vertical: "bottom",
            horizontal: "right",
          }}
        >
          <Box sx={{ p: 2, maxWidth: 300 }}>
            <Typography>Notifications</Typography>
            {/* Render your notifications here */}
          </Box>
        </Popover>

        {/* User Menu */}
        <IconButton onClick={handleOpenUserMenu} sx={{ p: 0 }}>
          <Badge color="success" variant="dot">
            <Avatar
              alt="John Doe"
              src="https://i.pravatar.cc/150?u=a04258114e29526708c"
            />
          </Badge>
        </IconButton>
        <Menu
          anchorEl={anchorElUser}
          open={Boolean(anchorElUser)}
          onClose={handleCloseUserMenu}
          anchorOrigin={{
            vertical: "top",
            horizontal: "right",
          }}
          transformOrigin={{
            vertical: "top",
            horizontal: "right",
          }}
        >
          <MenuItem>
            <Typography variant="body1" fontWeight="bold">
              Signed in as
            </Typography>
            <Typography variant="body2">johndoe@example.com</Typography>
          </MenuItem>
          <MenuItem onClick={() => console.log("My Settings")}>
            My Settings
          </MenuItem>
          <MenuItem onClick={() => console.log("Team Settings")}>
            Team Settings
          </MenuItem>
          <MenuItem onClick={() => console.log("Analytics")}>
            Analytics
          </MenuItem>
          <MenuItem onClick={() => console.log("System")}>System</MenuItem>
          <MenuItem onClick={() => console.log("Configurations")}>
            Configurations
          </MenuItem>
          <MenuItem onClick={() => console.log("Help & Feedback")}>
            Help & Feedback
          </MenuItem>
          <MenuItem onClick={handleLogout} sx={{ color: "red" }}>
            Log Out
          </MenuItem>
        </Menu>
      </Toolbar>
    </AppBar>
  );
}
