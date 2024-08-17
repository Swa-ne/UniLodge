import { checkEmailAvailability } from "../services/authentication/signup.services";


export interface CustomResponse {
    message?: string,
    error?: string,
    access_token?: string,
    httpCode: number
}

export const checkEveryInputForSignup = async (emailAddress: string, password: string, confirmationPassword: string): Promise<CustomResponse> => {
    if (!checkEmailValidity(emailAddress)) {
        return { error: 'Please enter a valid email address', "httpCode": 400 };
    }
    if (!checkPasswordValidity(password)) {
        return { error: 'Password must have at least one lowercase letter, one uppercase letter, one numeric digit, and one special character.', "httpCode": 400 };
    }
    if (!(await checkEmailAvailability(emailAddress))) {
        return { error: 'This email address is being used.', "httpCode": 409 };
    }
    if (password !== confirmationPassword) {
        return { error: "Those password didn't match. Try again.", "httpCode": 400 };
    }
    return { message: 'Success', "httpCode": 200 };
};

export const checkEveryInputForLogin = async (userIdentifier: string, password: string) => {
    if (!checkEmailValidity(userIdentifier)) {
        return { 'message': 'Please enter a valid email address', "httpCode": 200 };
    }
    if (!checkPasswordValidity(password)) {
        return { 'message': 'Sorry, looks like that\'s the wrong email or password.', "httpCode": 200 };
    }
    return { 'message': 'success', "httpCode": 200 };
};

export const checkEmailValidity = (emailAddress: string) => {
    // Validates an email address format (e.g., example@domain.com)
    const regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/;
    return regex.test(emailAddress);
};

export const checkPasswordValidity = (password: string) => {
    // least one lowercase letter, one uppercase letter, one numeric digit, and one special character
    const regex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s)./;
    return regex.test(password);
};
