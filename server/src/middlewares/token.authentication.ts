import { Request, Response, NextFunction } from 'express';
import jwt, { JwtPayload, TokenExpiredError, verify } from 'jsonwebtoken';
import { generateAccessTokenWithRefreshToken } from '../utils/generate.token';

export interface UserType {
    user_id: string;
    email: string;
    username: string;
    full_name: string;
}
interface AuthenticatedRequest extends Request {
    user?: UserType;
}

export async function authenticateToken(req: AuthenticatedRequest, res: Response, next: NextFunction) {
    try {
        const token = req.headers['authorization'];
        if (token == null) return res.status(401).json({ error: 'Unauthorized' });

        const user = verify(token, process.env.ACCESS_TOKEN_SECRET as string) as UserType;
        req.user = user;
        next();
    } catch (err) {
        if (err instanceof TokenExpiredError) {
            try {
                const user_refresh_token = req.cookies.refresh_token;
                if (!user_refresh_token) return res.status(401).json({ error: "Unauthorized request" });

                const decoded_token = jwt.verify(
                    user_refresh_token,
                    process.env.REFRESH_TOKEN_SECRET as string
                ) as jwt.JwtPayload;
                const refresh_access_token = await generateAccessTokenWithRefreshToken(decoded_token);
                if (refresh_access_token.httpCode !== 200) {
                    return res.status(refresh_access_token.httpCode).json({ error: refresh_access_token.error });
                }

                req.headers['authorization'] = `Bearer ${refresh_access_token.message}`;
                const user = verify(refresh_access_token.message as string, process.env.ACCESS_TOKEN_SECRET as string) as UserType;

                if (user && user.user_id && user.email && user.username && user.full_name) {
                    req.user = {
                        user_id: user.user_id,
                        email: user.email,
                        username: user.username,
                        full_name: user.full_name
                    };
                    next();
                } else {
                    return res.status(401).json({ error: 'Unauthorized' });
                }
            } catch (error) {
                console.log(error)
                return res.status(401).json({ error: 'Refresh token is invalid or expired' });
            }
        } else {
            return res.status(401).json({ error: 'Unauthorized' });
        }
    }
}
