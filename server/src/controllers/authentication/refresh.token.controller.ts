import { Request, Response } from 'express';

import jwt from 'jsonwebtoken';

import { UserType } from '../../middlewares/token.authentication';
import { User } from '../../models/authentication/user.model';
import { generateAccessTokenWithRefreshToken } from '../../utils/generate.token';

export const refreshAccessTokenController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user_refresh_token = req.cookies.refreshToken;

        if (!user_refresh_token) return res.status(401).json({ error: "Unauthorized request" })

        const decoded_token = jwt.verify(
            user_refresh_token,
            process.env.REFRESH_TOKEN_SECRET as string
        ) as jwt.JwtPayload

        const access_token = await generateAccessTokenWithRefreshToken(decoded_token)

        return res
            .status(200)
            .json({ message: "Access token refreshed", access_token })
    } catch (error) {
        if (error instanceof jwt.TokenExpiredError) {
            return res.status(401).json({ error: "Refresh token is expired" });
        }

        if (error instanceof jwt.JsonWebTokenError) {
            return res.status(401).json({ error: "Invalid refresh token" });
        }
        return res.status(500).json({ 'message': 'Internal Server Error' });;
    }

}
