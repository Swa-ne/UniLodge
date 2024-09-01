import multer from 'multer';
import { initializeApp } from 'firebase/app';
import { getStorage } from 'firebase/storage';

import config from '../config/firebase.config';

initializeApp(config.firebaseConfig);
export const storage = getStorage();
export const upload = multer({ storage: multer.memoryStorage() });
