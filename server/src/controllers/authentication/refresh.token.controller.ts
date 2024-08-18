import { Request, Response } from 'express';

import jwt from 'jsonwebtoken';

import { UserType } from '../../middlewares/token.authentication';
import { User } from '../../models/authentication/user.model';
import { generateAccessToken } from '../../utils/generate.token';

export const refreshAccessTokenController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user_refresh_token = req.cookies.refreshToken;

        if (!user_refresh_token) return res.status(401).json({ error: "Unauthorized request" })

        const decoded_token = jwt.verify(
            user_refresh_token,
            process.env.REFRESH_TOKEN_SECRET as string
        ) as jwt.JwtPayload

        const user = await User.findById(decoded_token?.user_id)

        if (!user) return res.status(401).json({ error: "Invalid refresh token" })


        if (decoded_token.refresh_token_version !== user.refresh_token_version) return res.status(401).json({ error: "Refresh token is invalid" });

        const access_token = await generateAccessToken(user._id.toString(), user.personal_email, user.username, user.full_name)

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
