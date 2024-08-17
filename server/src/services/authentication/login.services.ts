import { User, UserSchemaInterface } from "../../models/authentication/user.model";
import * as bcrypt from "bcrypt";

export const loginUsertoDatabase = async (user_identifier: string, password: string) => {
    try {
        let result = await User.findOne({ personal_email: { $regex: new RegExp(`^${user_identifier}$`, 'i') } });
        if (result) {
            if (await bcrypt.compare(password, result.password_hash)) {
                return { 'message': 'Success', "httpCode": 200 };
            }
            return { 'error': 'Sorry, looks like that\'s the wrong email or password.', "httpCode": 401 };
        }
        return { 'error': 'User not Found.', "httpCode": 404 };
    } catch {
        return { 'error': 'Internal Server Error.', "httpCode": 500 };
    }
};

export const getDataByEmailAddress = async (email_address: string): Promise<UserSchemaInterface | null> => {
    try {
        const result: UserSchemaInterface | null = await User.findOne({ personal_email: { $regex: new RegExp(`^${email_address}$`, 'i') } });
        return result;
    } catch (error) {
        return null;
    }
};
