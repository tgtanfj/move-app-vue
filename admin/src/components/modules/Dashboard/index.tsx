// "use client";

// import { useMediaQuery } from "@mui/material";
// import { Icon } from "@iconify/react";
// import {
//   Button,
//   Tooltip,
//   Box,
//   AppBar,
//   Toolbar,
//   Drawer,
//   Divider,
//   List,
//   ListItem,
//   ListItemIcon,
//   ListItemText,
//   Avatar,
//   CircularProgress,
// } from "@mui/material";
// import { useCallback, useEffect, useState } from "react";
// import { useRouter } from "next/router";
// import { toast } from "sonner";

// import LoadingScreen from "@/components/core/common/LoadingScreen";

// import Header from "./Header";

// import { AcmeIcon } from "@/components/core/common/icons";
// import { sectionNestedItems } from "@/helpers/data/sidebar-items";
// import { useVerifyTokenMutation } from "@/store/queries/auth";
// import webStorageClient from "@/utils/webStorageClient";
// import webLocalStorage from "@/utils/webLocalStorage";
// import { useAppSelector } from "@/hooks/redux-toolkit";

// function DashboardLayout({ children }: { children: React.ReactElement }) {
//   const isExpand = useAppSelector((state) => state.layout.isExpand);

//   const router = useRouter();
//   const isCompact = useMediaQuery("(max-width:768px)");
//   const [isAuth, setIsAuth] = useState<boolean>(false);
//   const [verifyToken] = useVerifyTokenMutation();

//   const handleVerifyToken = useCallback(async () => {
//     try {
//       if (!webStorageClient.get("_access_token")) {
//         toast.error("Bạn cần đăng nhập để truy cập trang này");
//       }
//       await verifyToken(webStorageClient.get("_access_token") || "??").unwrap();
//       setIsAuth(true);
//     } catch (error) {
//       setIsAuth(false);
//       webStorageClient.removeAll();
//       webLocalStorage.removeAll();
//       router.push(`/sign-in`);
//     }
//   }, [router]);

//   useEffect(() => {
//     handleVerifyToken();
//   }, [handleVerifyToken]);

//   return (
//     <>
//       {!isAuth ? (
//         <Box
//           sx={{
//             display: "flex",
//             justifyContent: "center",
//             alignItems: "center",
//             height: "100vh",
//           }}
//         >
//           <CircularProgress />
//         </Box>
//       ) : (
//         <Box sx={{ display: "flex", height: "100vh", width: "100%" }}>
//           {/* Sidebar */}
//           <Drawer
//             variant="permanent"
//             sx={{
//               width: isCompact || !isExpand ? 64 : 240,
//               flexShrink: 0,
//               "& .MuiDrawer-paper": {
//                 width: isCompact || !isExpand ? 64 : 240,
//                 boxSizing: "border-box",
//                 borderRight: "1px solid #e0e0e0",
//                 p: 2,
//               },
//             }}
//           >
//             <Toolbar>
//               <Box
//                 sx={{
//                   display: "flex",
//                   alignItems: "center",
//                   justifyContent:
//                     isCompact || !isExpand ? "center" : "flex-start",
//                   gap: 2,
//                 }}
//               >
//                 <Box
//                   sx={{
//                     display: "flex",
//                     alignItems: "center",
//                     justifyContent: "center",
//                     height: 32,
//                     width: 32,
//                     borderRadius: "50%",
//                     backgroundColor: "#13D0B4",
//                   }}
//                 >
//                   <AcmeIcon style={{ color: "#fff" }} />
//                 </Box>
//                 {!isCompact && isExpand && (
//                   <Typography
//                     variant="h6"
//                     sx={{ fontWeight: "bold", textTransform: "uppercase" }}
//                   >
//                     Next Exam
//                   </Typography>
//                 )}
//               </Box>
//             </Toolbar>

//             <Divider />

//             {/* Sidebar Items */}
//             <List>
//               {sectionNestedItems.map((item) => (
//                 <ListItem button key={item.key}>
//                   <ListItemIcon>
//                     <Icon icon={item.icon} width={24} />
//                   </ListItemIcon>
//                   {!isCompact && isExpand && (
//                     <ListItemText primary={item.label} />
//                   )}
//                 </ListItem>
//               ))}
//             </List>

//             {/* Bottom Buttons */}
//             <Box
//               sx={{
//                 mt: "auto",
//                 display: "flex",
//                 flexDirection: "column",
//                 alignItems: isCompact || !isExpand ? "center" : "flex-start",
//               }}
//             >
//               <Tooltip title="Help & Feedback" placement="right">
//                 <Button
//                   fullWidth={!isCompact}
//                   startIcon={
//                     <Icon icon="solar:info-circle-line-duotone" width={24} />
//                   }
//                   onClick={() => console.log("Help & Feedback")}
//                   sx={{
//                     justifyContent:
//                       isCompact || !isExpand ? "center" : "flex-start",
//                   }}
//                 >
//                   {!isCompact && isExpand && "Help & Information"}
//                 </Button>
//               </Tooltip>

//               <Tooltip title="Log Out" placement="right">
//                 <Button
//                   fullWidth={!isCompact}
//                   startIcon={
//                     <Icon
//                       icon="solar:minus-circle-line-duotone"
//                       width={24}
//                       className="rotate-180"
//                     />
//                   }
//                   onClick={() => handleLogout("redirect")}
//                   sx={{
//                     justifyContent:
//                       isCompact || !isExpand ? "center" : "flex-start",
//                     color: "red",
//                   }}
//                 >
//                   {!isCompact && isExpand && "Log Out"}
//                 </Button>
//               </Tooltip>
//             </Box>
//           </Drawer>

//           {/* Main Content */}
//           <Box sx={{ flexGrow: 1, overflow: "auto" }}>
//             <Header />
//             <main>{children}</main>
//           </Box>
//         </Box>
//       )}
//     </>
//   );
// }

// export default DashboardLayout;
