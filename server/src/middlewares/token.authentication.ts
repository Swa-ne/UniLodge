import { Request, Response, NextFunction } from 'express';
import { verify } from 'jsonwebtoken';

export interface UserType {
    user_id: string;
    email: string;
    username: string;
    full_name: string;
}
interface AuthenticatedRequest extends Request {
    user?: UserType;
}

export function authenticateToken(req: AuthenticatedRequest, res: Response, next: NextFunction) {
    const token = req.headers['authorization'];
    if (token == null) return res.status(401).json({ error: 'Unauthorized' });

    verify(token, process.env.ACCESS_TOKEN_SECRET as string, (err, user) => {
        if (err) return res.status(401).json({ error: 'Unauthorized' });
        req.user = user as UserType;
        next();
    });
}
