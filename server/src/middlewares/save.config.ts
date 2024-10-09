import multer, { FileFilterCallback } from 'multer';
import { initializeApp } from 'firebase/app';
import { deleteObject, getStorage, ref } from 'firebase/storage';

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

export const deleteImage = async (filePath: string) => {
    try {
        const url = extractFilePath(filePath);
        if (!url) {
            throw "File not found!";
        }
        const fileRef = ref(storage, url);

        await deleteObject(fileRef);
    } catch (error) {
        throw error;
    }
};

function extractFilePath(url: string): string | null {
    const regex = /\/o\/(.*?)\?alt=media/;
    const match = url.match(regex);

    if (match && match[1]) {
        return decodeURIComponent(match[1]);
    }

    return null;
}

export const uploadDorm = multer({ storage: multer.memoryStorage(), fileFilter: imageFilter });

export const uploadMessage = multer({ storage: multer.memoryStorage() });
