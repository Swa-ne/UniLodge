import rateLimit from "express-rate-limit";

export const loginLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 5,
});
export const forgetPasswordLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 3,
});
export const sendCodeLimiter = rateLimit({
    windowMs: 1 * 60 * 1000,
    max: 1,
});
export const saveDormLimiter = rateLimit({
    windowMs: 1 * 60 * 1000,
    max: 10,
});