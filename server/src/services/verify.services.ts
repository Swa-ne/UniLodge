import axios from 'axios';
import { getDownloadURL, ref, uploadBytesResumable } from 'firebase/storage';
import { deleteImage, storage } from '../middlewares/save.config';
import { VerifyUser } from '../models/verify.model';


const python_server = axios.create({
    baseURL: process.env.PYTHON_API_URL,
});

export const verifyFaceImage = async (user_id: string, image_file: Express.Multer.File) => {
    try {
        if (!image_file) {
            return { error: "Image not found", httpCode: 404 }
        }
        const storage_ref = ref(storage, `files/${image_file.originalname}SECRET${new Date()}`);

        const metadata = {
            contentType: image_file.mimetype,
        };

        const snapshot = await uploadBytesResumable(storage_ref, image_file.buffer, metadata);
        const download_url = await getDownloadURL(snapshot.ref);

        const image = await new VerifyUser({
            name: image_file.originalname,
            url: download_url,
            user_id,
            type: "Face Image"
        }).save();

        const data = { face: download_url };
        const result = await python_server.post(`/check-face`, data);
        if (result.data === "Success") return { message: result.data, httpCode: 200 }

        await deleteImage(download_url)
        await VerifyUser.findByIdAndDelete(image._id);

        return { error: result.data, httpCode: 400 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const verifyIDImage = async (user_id: string, image_file: Express.Multer.File) => {
    try {
        if (!image_file) {
            return { error: "Image not found", httpCode: 404 }
        }
        const storage_ref = ref(storage, `files/${image_file.originalname}SECRET${new Date()}`);

        const metadata = {
            contentType: image_file.mimetype,
        };

        const snapshot = await uploadBytesResumable(storage_ref, image_file.buffer, metadata);
        const download_url = await getDownloadURL(snapshot.ref);

        const image = await new VerifyUser({
            name: image_file.originalname,
            url: download_url,
            user_id,
            type: "ID Image"
        }).save();

        const data = { id: download_url };
        const result = await python_server.post(`/check-id`, data);

        if (result.data === "Success") return { message: result.data, httpCode: 200 }

        await deleteImage(download_url)
        await VerifyUser.findByIdAndDelete(image._id);

        return { error: result.data, httpCode: 400 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const verifyUser = async (user_id: string) => {
    try {

        const face = await VerifyUser.findOne({ user_id, type: "Face Image" }).sort({ _id: -1 });
        const id = await VerifyUser.findOne({ user_id, type: "ID Image" }).sort({ _id: -1 });
        const data = { face: face?.url, id: id?.url };
        console.log(data)
        const result = await python_server.post(`/verify-user`, data);

        if (result.data === "Success") return { message: result.data, httpCode: 200 }

        return { error: result.data, httpCode: 400 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}
