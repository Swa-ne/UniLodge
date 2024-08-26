import * as bcrypt from "bcrypt";
import { User, UserSchemaInterface } from "../../models/authentication/user.model";
import { CustomResponse } from "../../utils/input.validators";
import { sendEmailCode } from "../index.services";
import { generateAccessToken } from "../../utils/generate.token";

export const signupUsertoDatabase = async (
    first_name: string,
    middle_name: string | undefined,
    last_name: string,
    username: string,
    personal_email: string,
    personal_number: string | undefined,
    birthday: Date,
    password: string
): Promise<CustomResponse> => {
    let userCredentialResult;

    try {
        const saltRounds = await bcrypt.genSalt();
        const password_hash = await bcrypt.hash(password, saltRounds);
        userCredentialResult = await new User({
            first_name,
            middle_name,
            last_name,
            username,
            full_name: `${first_name} ${middle_name && `${middle_name} `}${last_name}`,
            personal_email,
            personal_number,
            birthday,
            password_hash
        }).save();

        await sendEmailCode(`${userCredentialResult._id}`, personal_email, first_name)

        const access_token = await generateAccessToken(`${userCredentialResult._id}`,)
        if (access_token.httpCode === 200) {
            return {
                message: "Congratulations, your account has been successfully created",
                access_token: access_token.message,
                httpCode: 200
            };
        }
        return { error: access_token.error, httpCode: access_token.httpCode }
    } catch (error) {
        if (userCredentialResult) {
            await userCredentialResult.deleteOne();
        }
        return { error: "Internal Server Error", httpCode: 500 };
    }
};

export const checkEmailAvailability = async (emailAddress: string): Promise<boolean> => {
    try {
        const result: boolean = (await User.findOne({ personal_email: { $regex: new RegExp(`^ ${emailAddress} $`, 'i') } })) === null;
        return result;
    } catch (error) {
        return false;
    }
};

export const getDataByEmailAddress = async (emailAddress: string): Promise<UserSchemaInterface | null> => {
    try {
        const result: UserSchemaInterface | null = await User.findOne({ personal_email: { $regex: new RegExp(`^ ${emailAddress} $`, 'i') } });
        return result;
    } catch (error) {
        return null;
    }
};
