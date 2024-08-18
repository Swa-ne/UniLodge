import { Router } from "express";


import { resendEmailCodeController, signupUserController, verifyEmailCodeController } from "../controllers/authentication/signup.controller";
import { authenticateToken } from "../middlewares/token.authentication";
import { loginUserController } from "../controllers/authentication/login.controller";

const router = Router();

router.post("/signup", signupUserController);
router.post("/resend-verification", authenticateToken, resendEmailCodeController);
router.post("/verify-code", authenticateToken, verifyEmailCodeController);

router.post("/login", loginUserController);

export default router;