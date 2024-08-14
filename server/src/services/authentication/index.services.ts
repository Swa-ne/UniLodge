import axios, { AxiosResponse } from 'axios';
import { UserValidCode } from '../../models/authentication/user.model';
import { ObjectId } from 'mongoose';

const client = axios.create({
    baseURL: process.env.PYTHON_API_URL,
});

export const sendEmailCode = async (user_id: ObjectId, receiver: string, name: string) => {
    try {
        const code = Math.floor(100000 + Math.random() * 900000);
        const data = { code, receiver, name };
        await new UserValidCode({
            user_id,
            code,
            expiresAt: new Date(Date.now() + 20 * 60 * 1000)
        }).save();
        await client.post(`/send-email-code`, data);
    } catch (error) {
        console.error(error);
    }
}