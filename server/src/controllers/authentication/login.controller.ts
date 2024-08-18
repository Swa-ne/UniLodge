import { Request, Response } from 'express';

import { checkEveryInputForLogin } from '../../utils/input.validators';
import { changePassword, getDataByEmailAddress, isOldPasswordSimilar, loginUsertoDatabase } from '../../services/authentication/login.services';
import { generateAccessAndRefereshTokens } from '../../services/authentication/index.services';
import { UserType } from '../../middlewares/token.authentication';

export const loginUserController = async (req: Request, res: Response) => {
    try {
        const { email_address, password } = req.body;
        const checker_for_input = await checkEveryInputForLogin(email_address, password);

        if (checker_for_input.httpCode === 200) {
            const data = await loginUsertoDatabase(email_address, password);
            let loginUpdate: any = data.message;

            if (data.httpCode === 200) {
                const user_data = await getDataByEmailAddress(email_address);

                if (!user_data) return res.status(404).json({ error: "User not found" });

                const { access_token, refresh_token } = await generateAccessAndRefereshTokens(user_data._id.toString());
                loginUpdate = { loginUpdate, accessToken: access_token };

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
            return res.status(data.httpCode).json(loginUpdate);
        }
        return res.status(checker_for_input.httpCode).json(checker_for_input.message);;
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });;
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
