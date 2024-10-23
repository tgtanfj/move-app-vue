import { config } from 'dotenv';
import * as admin from 'firebase-admin';
config();

const serviceAccount = {
  project_id: process.env.PROJECT_ID,
  private_key: process.env.PRIVATE_KEY.replace(/\\n/gm, '\n'),
  client_email: process.env.CLIENT_EMAIL,
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
  databaseURL: 'https://move-project-51201-default-rtdb.asia-southeast1.firebasedatabase.app/',
});

export const firebaseAdmin = admin;
export const db = admin.database();
