import { Request, Response } from 'express';
import jwt, { TokenExpiredError } from 'jsonwebtoken';

import { checkEveryInputForLogin, checkUsernameValidity } from '../../utils/input.validators';
import { changePassword, editProfile, getDataByEmailAddress, isOldPasswordSimilar, loginUsertoDatabase } from '../../services/authentication/login.services';
import { generateAccessAndRefereshTokens, getCurrentUserByEmail, getCurrentUserById, sendEmailForgetPassword } from '../../services/index.services';
import { UserType } from '../../middlewares/token.authentication';
import { checkUsernameAvailability } from '../../services/authentication/signup.services';


export const loginUserController = async (req: Request, res: Response) => {
    try {
        const { email_address, password } = req.body;
        const checker_for_input = await checkEveryInputForLogin(email_address, password);

        if (checker_for_input.httpCode === 200) {
            const data = await loginUsertoDatabase(email_address, password);

            if (data.httpCode === 200) {
                const user_data = await getDataByEmailAddress(email_address);

                if (!user_data) return res.status(404).json({ error: "User not found" });

                const result = await generateAccessAndRefereshTokens(user_data._id.toString());
                if (result.httpCode !== 200) return res.status(result.httpCode).json({ error: result.error })

                return res
                    .status(200)
                    .cookie(
                        "refresh_token",
                        result.message?.refresh_token,
                        {
                            httpOnly: true,
                            secure: true,
                            sameSite: 'none',
                        }
                    )
                    .json({ message: "Success", access_token: result.message?.access_token });
            }
            return res.status(data.httpCode).json({ error: data.error });
        }
        return res.status(checker_for_input.httpCode).json({ error: checker_for_input.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
};

export const changePasswordController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) return res.status(404).json({ error: "User not found" });

        const { old_password, new_password, confirmation_password } = req.body;

        if (new_password !== confirmation_password) return res.status(400).json({ error: "New password does not match. Enter new password again here." });

        const is_old_password_similar = await isOldPasswordSimilar(user.user_id, old_password);
        if (is_old_password_similar.httpCode === 200) {
            await changePassword(user.user_id, new_password)
        }
        return res.status(is_old_password_similar.httpCode).json({ error: is_old_password_similar.error })
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}
export const editProfileController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) return res.status(404).json({ error: "User not found" });

        const { first_name, middle_name, last_name, username, bio, personal_number, birthday } = req.body;

        const requiredFields = {
            first_name,
            last_name,
            username,
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

        if (!checkUsernameValidity(username)) {
            return res.status(400).json({ error: 'Please enter a valid username' });
        }
        if (!(await checkUsernameAvailability(username))) {
            return res.status(409).json({ error: 'This usernmae is being used.' });
        }

        const data = await editProfile(user.user_id, first_name, middle_name, last_name, username, bio, personal_number, birthday);
        if (data.httpCode !== 200) {
            return res.status(500).json({ error: data.error });
        }
        return res.status(200).json({ message: data.message });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}

export const forgotPasswordController = async (req: Request, res: Response) => {
    try {
        const { personal_email } = req.body;
        const user = await getCurrentUserByEmail(personal_email);
        if (!user) return res.status(404).json({ error: "User not found" })

        const token = jwt.sign({ email: user.personal_email, user_id: user._id }, process.env.ACCESS_TOKEN_SECRET as string, {
            expiresIn: "120m",
        });
        await sendEmailForgetPassword(user._id.toString(), personal_email, user.full_name)
        return res.status(200).json({ message: "Success", token });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}

export const postResetPasswordController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }
        const { user_id } = user;
        const { password, confirmation_password } = req.body;

        if (password !== confirmation_password) {
            return res.status(400).json({ error: "Those password didn't match. Try again." });
        }

        const result = await getCurrentUserById(user_id);
        if (!result) return res.status(404).json({ error: "User not found" });

        const { httpCode, message, error } = await changePassword(user_id, password);

        if (httpCode === 200) return res.status(httpCode).json({ message })
        return res.status(httpCode).json({ error })
    } catch (error) {
        if (error instanceof TokenExpiredError) {
            return res.status(401).json({ error: "Token has expired" });
        }
        return res.status(500).json({ error: "Internal Server Error" });
    }
}
