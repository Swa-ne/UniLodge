import { Request, Response } from 'express';
import { checkEmailAvailability, checkEmailVerified, checkUsernameAvailability, signupUsertoDatabase } from '../../services/authentication/signup.services';
import { UserSchemaInterface } from '../../models/authentication/user.model';
import { checkEveryInputForSignup, validateBioLength } from '../../utils/input.validators';
import { generateAccessAndRefereshTokens, sendEmailCode, verifyEmailCode } from '../../services/index.services';
import { UserType } from '../../middlewares/token.authentication';

interface CustomRequestBody extends UserSchemaInterface {
    confirmation_password: string,
    valid_email: boolean
}

export const checkEmailVerifiedController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        const { user_id } = user;
        const result = await checkEmailVerified(user_id);
        if (result) {
            return res.status(200).json({ message: "Success" });
        }
        return res.status(403).json({ message: "Email is not yet verified" });
    } catch (e) {
        return res.status(500).json({ error: "Internal Server Error" });
    }
}

export const checkUsernameAvailabilityController = async (req: Request, res: Response) => {
    try {
        let username: string = req.body.username;
        if (!username) return res.status(404).json({ error: "Username not found" });
        if (!(await checkUsernameAvailability(username))) {
            return res.status(409).json({ error: 'This username is being used.' });
        }
        return res.status(200).json({ message: "Success" });
    } catch (e) {
        return res.status(500).json({ error: "Internal Server Error" });
    }
}

export const checkEmailAvailabilityController = async (req: Request, res: Response) => {
    try {
        let personal_email: string = req.body.personal_email;
        if (!personal_email) return res.status(404).json({ error: "Email address not found" });
        personal_email = personal_email.toLowerCase();
        if (!(await checkEmailAvailability(personal_email))) {
            return res.status(409).json({ error: 'This email address is being used.' });
        }
        return res.status(200).json({ message: "Success" });
    } catch (e) {
        return res.status(500).json({ error: "Internal Server Error" });
    }
}

export const signupUserController = async (req: Request, res: Response) => {
    try {
        const { first_name, middle_name, last_name, username, bio, password_hash, confirmation_password, personal_number, birthday, valid_email }: CustomRequestBody = req.body;
        let personal_email: string = req.body.personal_email;
        if (!personal_email) return res.status(404).json({ error: "Email address not found" });
        personal_email = personal_email.toLowerCase()

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
            if (!value) {
                return res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
            }
        }

        if (!validateBioLength(bio)) {
            return res.status(400).json({ error: 'Bio exceeds the maximum allowed length of 80 words. Please shorten your bio.' });
        }

        const checkerForInput = await checkEveryInputForSignup(username, personal_email, password_hash, confirmation_password);
        if (checkerForInput.message === 'Success') {
            const data = await signupUsertoDatabase(first_name, middle_name, last_name, username, bio, personal_email, personal_number, birthday, password_hash, valid_email);
            if (data.httpCode !== 200) {
                return res.status(500).json({ error: data.error });
            }
            return res
                .status(200)
                .cookie(
                    "refresh_token",
                    data.refresh_token,
                    {
                        httpOnly: true,
                        secure: true,
                        sameSite: 'none',
                    }
                )
                .json({ message: "Success", access_token: data.access_token, user_id: data.user_id });
        }

        return res.status(checkerForInput.httpCode).json({ error: checkerForInput.error });
    } catch (error) {
        console.log(error)
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
            const result_token = await generateAccessAndRefereshTokens(user_id);
            return res
                .status(200)
                .cookie(
                    "refresh_token",
                    result_token.message?.refresh_token,
                    {
                        httpOnly: true,
                        secure: true,
                        sameSite: 'none',
                    }
                )
                .json({ message: "Success", access_token: result_token.message?.access_token, user_id });
        }
        return res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}