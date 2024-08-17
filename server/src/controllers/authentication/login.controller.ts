import { Request, Response } from 'express';

import { checkEveryInputForLogin } from '../../utils/input.validators';
import { loginUsertoDatabase } from '../../services/authentication/login.services';
import { getDataByEmailAddress } from '../../services/authentication/signup.services';
import { generateAccessAndRefereshTokens } from '../../services/authentication/index.services';

export const loginUserController = async (req: Request, res: Response) => {
    try {
        const { email_address, password } = req.body;
        const checker_for_input = await checkEveryInputForLogin(email_address, password);

        if (checker_for_input.httpCode === 200) {
            const data = await loginUsertoDatabase(email_address, password);
            let loginUpdate: any = data.message;

            if (data.httpCode === 200) {
                const user_data = await getDataByEmailAddress(email_address);

                const user = {
                    email: email_address,
                    user_id: user_data?._id,
                    full_name: user_data?.full_name,
                    username: user_data?.username
                }

                if (!user_data) {
                    return res.status(404).json({ error: "User not found" });
                }

                const { access_token, refresh_token } = await generateAccessAndRefereshTokens(user_data._id.toString());
                loginUpdate = { loginUpdate, accessToken: access_token };

                const options = {
                    httpOnly: true,
                    secure: true
                }

                return res
                    .status(200)
                    .cookie("refresh_token", refresh_token, options)
                    .json({ message: "Success", access_token });
            }
            return res.status(data.httpCode).json(loginUpdate);;
        }
        return res.status(checker_for_input.httpCode).json(checker_for_input.message);;
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });;
    }
};