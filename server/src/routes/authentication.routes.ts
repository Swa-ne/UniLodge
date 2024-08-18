import { Router } from "express";


import { resendEmailCodeController, signupUserController, verifyEmailCodeController } from "../controllers/authentication/signup.controller";
import { authenticateToken } from "../middlewares/token.authentication";
import { loginUserController } from "../controllers/authentication/login.controller";
import { logoutUserController } from "../controllers/authentication/logout.controller";

const router = Router();

router.post("/signup", signupUserController);
router.post("/resend-verification", authenticateToken, resendEmailCodeController);
router.post("/verify-code", authenticateToken, verifyEmailCodeController);

router.post("/login", loginUserController);
router.post("/logout", authenticateToken, logoutUserController);

export default router;