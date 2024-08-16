import axios, { AxiosResponse } from 'axios';
import { User, UserValidCode, UserValidCodeSchemaInterface } from '../../models/authentication/user.model';
import { ObjectId } from 'mongoose';
import { generateAccessToken, generateRefreshToken } from '../../utils/generate.token';
import { CustomResponse } from '../../utils/input.validators';

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

export const verifyEmailCode = async (user_id: ObjectId, code: string): Promise<CustomResponse> => {
    try {
        const user: UserValidCodeSchemaInterface | null = await UserValidCode.findOne({ user_id });
        if (!user) return { error: "User not found", httpCode: 404 }
        const result: boolean = user.code === code;
        if (!result) return { error: "Invalid Code", httpCode: 400 }
        return { message: "Success", httpCode: 200 }
    } catch (error) {
        console.error(error);
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const generateAccessAndRefereshTokens = async (user_id: string) => {
    try {
        const user = await User.findById(user_id)
        if (!user) {
            return { error: "User not found", httpCode: 404 }
        }
        const access_token = await generateAccessToken(user._id.toString(), user.personal_email, user.username, user.full_name)
        const refresh_token = await generateRefreshToken(user._id.toString())

        user.refresh_token = refresh_token
        await user.save()

        return { access_token, refresh_token }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}