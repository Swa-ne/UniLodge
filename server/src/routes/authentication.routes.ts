import { Router } from "express";


import { resendEmailCodeController, signupUserController, verifyEmailCodeController } from "../controllers/authentication/signup.controller";
import { authenticateToken } from "../middlewares/token.authentication";

const router = Router();

router.post("/signup", signupUserController);
router.post("/resend-verification", authenticateToken, resendEmailCodeController);
router.post("/verify-code", authenticateToken, verifyEmailCodeController);

export default router;