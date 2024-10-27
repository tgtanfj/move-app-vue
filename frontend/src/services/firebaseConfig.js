// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getDatabase, ref  } from "firebase/database";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDkyzoGqlHuWDTt7ATMobLfqVUMqLFU1WE",
  authDomain: "move-project-51201.firebaseapp.com",
  databaseURL: "https://move-project-51201-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "move-project-51201",
  storageBucket: "move-project-51201.appspot.com",
  messagingSenderId: "975891640382",
  appId: "1:975891640382:web:1afe88ef3be81d1e9a616f"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const database = getDatabase(app);
const auth = getAuth(app);

export { database, auth, ref }