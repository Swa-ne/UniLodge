import { Request, Response } from 'express';
import { signupUsertoDatabase } from '../../services/authentication/signup.services';

import { UserSchemaInterface } from '../../models/authentication/user.model';
import { checkEveryInputForSignup } from '../../utils/input.validators';
import { generateAccessAndRefereshTokens, sendEmailCode, verifyEmailCode } from '../../services/authentication/index.services';

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
                return res.status(400).json({ error: `${key} is required and cannot be null or undefined.` });
            }
        }

        const checkerForInput = await checkEveryInputForSignup(emailAddress, password_hash, confirmation_password);
        if (checkerForInput.message === 'Success') {
            const data = await signupUsertoDatabase(first_name, middle_name, last_name, emailAddress, personal_number, birthday, password_hash);
            if (data.httpCode !== 200) {
                return res.status(500).json({ error: data.error });
            }
            return res.status(data.httpCode).json({ message: data.message, user_details: data.user_details });
        }

        return res.status(checkerForInput.httpCode).send({ message: checkerForInput.message });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
};

export const resendEmailCodeController = async (req: Request, res: Response) => {
    try {
        const { user_id, email, name } = req.body;
        await sendEmailCode(user_id, email, name);
        return res.status(200).json({ message: "Success" });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}

export const verifyEmailCodeController = async (req: Request, res: Response) => {
    const options = {
        httpOnly: true,
        secure: true
    }
    try {
        const { user_id, code } = req.body;
        const result = await verifyEmailCode(user_id, code);
        if (result.httpCode === 200) {
            const { access_token, refresh_token } = await generateAccessAndRefereshTokens(user_id);
            return res
                .status(200)
                .cookie("refresh_token", refresh_token, options)
                .json({ message: "Success", access_token });
        }
        return res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}

