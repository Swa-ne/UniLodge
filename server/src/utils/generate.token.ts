import jwt from 'jsonwebtoken';
import { getUserRefreshToken } from '../services/authentication/index.services';

export const generateAccessToken = async (user_id: string, email: string, username: string, full_name: string): Promise<string> => {
    return jwt.sign(
        {
            user_id,
            email,
            username,
            full_name
        },
        process.env.ACCESS_TOKEN_SECRET as string,
        {
            expiresIn: "30m"
        }
    )
};

export const generateRefreshToken = async (user_id: string): Promise<string> => {
    const refresh_token_version = await getUserRefreshToken(user_id)
    return jwt.sign(
        {
            user_id,
            refresh_token_version
        },
        process.env.REFRESH_TOKEN_SECRET as string,
        {
            expiresIn: "180d"
        }
    )
};