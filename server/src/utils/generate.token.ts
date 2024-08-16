import jwt from 'jsonwebtoken';

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
    return jwt.sign(
        {
            user_id,
        },
        process.env.REFRESH_TOKEN_SECRET as string,
        {
            expiresIn: "180d"
        }
    )
};