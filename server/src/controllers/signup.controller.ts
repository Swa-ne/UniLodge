import { Request, Response } from 'express';
import { signupUsertoDatabase } from '../services/authentication/signup.services';

import { UserSchemaInterface } from '../models/authentication/user.model';
import { checkEveryInputForSignup } from '../utils/input.validators';

interface CustomRequestBody extends UserSchemaInterface {
    confirmation_password: string
}

export const signupUserController = async (req: Request, res: Response) => {
    try {
        const { first_name, middle_name, last_name, password_hash, confirmation_password, personal_number, birthday }: CustomRequestBody = req.body;
        const emailAddress: string = req.body.emailAddress.toLowerCase();

        const requiredFields = {
            first_name,
            last_name,
            password_hash,
            confirmation_password,
            personal_number,
            birthday,
        };

        for (const [key, value] of Object.entries(requiredFields)) {
            if (value == null) {
                return res.status(400).json(`${key} is required and cannot be null or undefined.`);
            }
        }

        const checkerForInput = await checkEveryInputForSignup(emailAddress, password_hash, confirmation_password);
        if (checkerForInput.message === 'success') {
            const data = await signupUsertoDatabase(first_name, middle_name, last_name, emailAddress, personal_number, birthday, password_hash);
            if (data.httpCode !== 200) {
                return res.status(500).json(data.error);;
            }
            return res.status(data.httpCode).json(data.message);
        }

        return res.status(checkerForInput.httpCode).json(checkerForInput.message);;

    } catch (error) {
        res.status(500).json("Internal Server Error");

    }
};
