import { Request, Response } from 'express';
import { UserType } from '../middlewares/token.authentication';
import { verifyFaceImage, verifyIDImage, verifyUser } from '../services/verify.services';

export const verifyFaceImageController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });


        const { user_id } = user;
        if (!user_id) return res.status(400).json({ message: 'User ID not provided' });

        const image_file: Express.Multer.File | undefined = req.file as Express.Multer.File | undefined;

        if (!image_file) {
            return res.status(400).json({ error: "No files uploaded" });
        }

        const result = await verifyFaceImage(
            user_id,
            image_file,
        );

        if (result.httpCode === 200) return res.status(result.httpCode).json({ 'message': result.message });
        return res.status(result.httpCode).json({ 'error': result.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}
export const verifyIDImageController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });


        const { user_id } = user;
        if (!user_id) return res.status(400).json({ message: 'User ID not provided' });

        const image_file: Express.Multer.File | undefined = req.file as Express.Multer.File | undefined;
        console.log(image_file)
        if (!image_file) {
            return res.status(400).json({ error: "No files uploaded" });
        }

        const result = await verifyIDImage(
            user_id,
            image_file,
        );

        if (result.httpCode === 200) return res.status(result.httpCode).json({ 'message': result.message });
        return res.status(result.httpCode).json({ 'error': result.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}
export const verifyUserController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });


        const { user_id } = user;
        if (!user_id) return res.status(400).json({ message: 'User ID not provided' });

        const result = await verifyUser(
            user_id,
        );

        if (result.httpCode === 200) return res.status(result.httpCode).json({ 'message': result.message });
        return res.status(result.httpCode).json({ 'error': result.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}