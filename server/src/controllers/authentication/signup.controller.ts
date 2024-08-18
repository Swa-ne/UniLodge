import { Request, Response } from 'express';
import { signupUsertoDatabase } from '../../services/authentication/signup.services';

import { UserSchemaInterface } from '../../models/authentication/user.model';
import { checkEveryInputForSignup } from '../../utils/input.validators';
import { generateAccessAndRefereshTokens, sendEmailCode, verifyEmailCode } from '../../services/authentication/index.services';
import { UserType } from '../../middlewares/token.authentication';

interface CustomRequestBody extends UserSchemaInterface {
    confirmation_password: string
}

export const signupUserController = async (req: Request, res: Response) => {
    try {
        const { first_name, middle_name, last_name, username, password_hash, confirmation_password, personal_number, birthday }: CustomRequestBody = req.body;
        const personal_email: string = req.body.personal_email.toLowerCase();

        const requiredFields = {
            first_name,
            last_name,
            username,
            personal_email,
            password_hash,
            confirmation_password,
            personal_number,
            birthday,
        };

        const updatedKey: { [key: string]: string } = {
            first_name: "First Name",
            last_name: "Last Name",
            username: "Username",
            personal_email: "Email Address",
            password_hash: "Password",
            confirmation_password: "Confirmation Password",
            personal_number: "Phone Number",
            birthday: "Birthday",
        }
        for (const [key, value] of Object.entries(requiredFields)) {
            if (value == null) {
                return res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
            }
        }

        const checkerForInput = await checkEveryInputForSignup(personal_email, password_hash, confirmation_password);
        if (checkerForInput.message === 'Success') {
            const data = await signupUsertoDatabase(first_name, middle_name, last_name, username, personal_email, personal_number, birthday, password_hash);
            if (data.httpCode !== 200) {
                return res.status(500).json({ error: data.error });
            }
            return res.status(data.httpCode).json({ message: data.message, user_details: data.access_token });
        }

        return res.status(checkerForInput.httpCode).send({ message: checkerForInput.message });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
};

export const resendEmailCodeController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        const { user_id, email, full_name } = user;
        await sendEmailCode(user_id, email, full_name);
        return res.status(200).json({ message: "Success" });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}

export const verifyEmailCodeController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        const { user_id } = user;
        const { code } = req.body;
        const result = await verifyEmailCode(user_id, code);
        if (result.httpCode === 200) {
            const { access_token, refresh_token } = await generateAccessAndRefereshTokens(user_id);
            return res
                .status(200)
                .cookie(
                    "refresh_token",
                    refresh_token,
                    {
                        httpOnly: true,
                        secure: true
                    }
                )
                .json({ message: "Success", access_token });
        }
        return res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}