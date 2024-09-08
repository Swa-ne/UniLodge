import multer, { FileFilterCallback } from 'multer';
import { initializeApp } from 'firebase/app';
import { getStorage } from 'firebase/storage';

import config from '../config/firebase.config';
import { Request } from 'express';

initializeApp(config.firebaseConfig);
export const storage = getStorage();

const imageFilter = (req: Request, file: Express.Multer.File, cb: FileFilterCallback) => {
    if (file.mimetype.startsWith("image/")) {
        cb(null, true);
    } else {
        cb(new Error("Only image files are allowed"));
    }
};

export const uploadDorm = multer({ storage: multer.memoryStorage(), fileFilter: imageFilter });

export const uploadMessage = multer({ storage: multer.memoryStorage() });
