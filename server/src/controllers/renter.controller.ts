import { Request, Response } from 'express';
import { UserType } from '../middlewares/token.authentication';
import { getDorms } from '../services/renter.services';

export const getDormsController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const dorms = await getDorms();
        if (dorms.httpCode === 200) return res.status(dorms.httpCode).json({ 'message': dorms.message });
        return res.status(dorms.httpCode).json({ 'error': dorms.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}