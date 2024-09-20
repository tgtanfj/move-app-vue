# Move App
 ### Overview
This is the Intern's project 2024. In this project we build an application for viewers to watch videos about exercise, gym are uploaded by instructors. This application is using Flutter and runs on mobile devices.
This project start at 23/09/2024 to 08/11/2024
 #### Members
Madison - Mobile Intern Team - 2024 has 5 members:

| * | Name | 
|---|---|
| 1 | Trần Thị Huyền Diệu | 
| 2 | Phan Thị Kiều Mơ |
| 3 | Trần Minh Nhật| 
| 4 | Lô Tiến Đạt | 
| 5 | Thị Vi |
 #### Package
Some Flutter's packages we're using in this project:
1. flick_video
2. firebase_auth
3. flutter_bloc 
4. bloc
5. flutter_svg
6. share_plus
7. firebase_auth
8. google_sign_in
9. facebook_sign_in
10. firebase_core
11. dio
12. equatable
13. share_preferences
 #### Folder Structure
 Based on layer-first structure
 ```
assets/
├─ icons/  	              # Icons to use across the app 
├─ images/		      # Images to use across the app
├─ fonts/	              # Custom fonts used throughout the app
│   
lib/                          # Root Package (Main application logic)
├─ constants/                 # Stores common constants used across the app
├─ data/                      # Data Layer 
│   ├─ models/                # Data Models
│   ├─ services/              # Service Layer
│   ├─ data_sources/          # Data Sources
│       ├─ local/             # Handles local data storage 
│       ├─ remote/            # Handles remote data fetching (API, Firebase, etc.)
│   ├─ repositories/          # Repositories for data management and interaction
├─ presentation/              # UI Layer
│   ├─ routes/
│   ├─ screens/               # App Screens
│       ├─ home/              # Home screen
│           ├─ bloc/          # Business logic components
│           ├─ page/          # Actual page layout for home
│           ├─ widget/        # Widgets used in the home screen
│   ├─ components/            # Reusable UI components
├─ configs/                   # Configuration Files 
│   ├─ app_config.dart        # Application configuration 
│   ├─ themes/                # Theming
├─ utils/                     # Utility functions/helpers
main.dart                     # Entry point for the Flutter application 
.gitignore                    # Specifies which files and directories to ignore in version control
README.md                     # Documentation for the project
 ```
#### Set Up Project

