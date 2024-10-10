import axios from 'axios';
import { User, UserSchemaInterface } from '../models/authentication/user.model';
import { UserValidCode, UserValidCodeSchemaInterface } from '../models/authentication/valid.code.model';
import { generateAccessToken, generateRefreshToken } from '../utils/generate.token';
import { CustomResponse } from '../utils/input.validators';
import { Dorm } from '../models/dorm/dorm.model';

const python_server = axios.create({
    baseURL: process.env.PYTHON_API_URL,
});

export const sendEmailCode = async (user_id: string, receiver: string, name: string) => {
    try {
        const code = Math.floor(100000 + Math.random() * 900000);
        const data = { code, receiver, name };
        const user: UserValidCodeSchemaInterface | null = await UserValidCode.findOne({ user_id });
        if (user) {
            user.code = code.toString();
            user.expiresAt = new Date(Date.now() + 20 * 60 * 1000);
            await user.save();
        } else {
            await new UserValidCode({
                user_id,
                code,
                expiresAt: new Date(Date.now() + 20 * 60 * 1000)
            }).save();
        }
        await python_server.post(`/send-email-code`, data);
        return { message: "Success", httpCode: 200 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}
export const sendEmailForgetPassword = async (user_id: string, receiver: string, name: string) => {
    try {
        const code = Math.floor(100000 + Math.random() * 900000);
        const data = { code, receiver, name };
        const user: UserValidCodeSchemaInterface | null = await UserValidCode.findOne({ user_id });
        if (user) {
            user.code = code.toString();
            user.expiresAt = new Date(Date.now() + 2 * 60 * 60 * 1000);
            await user.save();
        } else {
            await new UserValidCode({
                user_id,
                code,
                expiresAt: new Date(Date.now() + 2 * 60 * 60 * 1000)
            }).save();
        }
        await python_server.post(`/send-email-forget-password`, data);

        return { message: "Success", httpCode: 200 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const verifyEmailCode = async (user_id: string, code: string): Promise<CustomResponse> => {
    try {
        const user: UserValidCodeSchemaInterface | null = await UserValidCode.findOne({ user_id });
        if (!user) return { error: "User not found", httpCode: 404 };
        if (user.expiresAt < new Date()) return { error: "Code expired", httpCode: 400 };
        const result: boolean = user.code === code;
        if (!result) return { error: "Invalid Code", httpCode: 400 };
        await UserValidCode.deleteOne({ user_id });
        await User.findByIdAndUpdate(
            user_id,
            { valid_email: true },
        );
        return { message: "Success", httpCode: 200 };
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
        const access_token = await generateAccessToken(user_id)
        const refresh_token = await generateRefreshToken(user._id.toString())

        return { message: { access_token: access_token.message, refresh_token }, httpCode: 200 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const getUserRefreshToken = async (user_id: string) => {
    try {
        const user = await User.findById(user_id)
        if (!user) {
            return { error: "User not found", httpCode: 404 }
        }
        return user.refresh_token_version
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const getCurrentUserByEmail = async (personal_email: string): Promise<UserSchemaInterface | null> => {
    try {
        const user = await User.findOne({ personal_email });
        if (!user) return null;

        return user
    } catch (error) {
        return null
    }
}

export const getCurrentUserById = async (user_id: string): Promise<UserSchemaInterface | null> => {
    try {
        const user = await User.findById(user_id);
        if (!user) return null;

        return user
    } catch (error) {
        return null
    }
}

export const userExists = async (userId: string): Promise<boolean> => {
    try {
        const user = await User.findById(userId).exec();
        return !!user;
    } catch (error) {
        return false
    }
};

export const dormExists = async (dorm_id: string): Promise<boolean> => {
    try {
        const dorm = await Dorm.findById(dorm_id).exec();
        return !!dorm;
    } catch (error) {
        return false
    }
};
