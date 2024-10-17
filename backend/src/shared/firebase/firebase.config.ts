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
});

export const firebaseAdmin = admin;
