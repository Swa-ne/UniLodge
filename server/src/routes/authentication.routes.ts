import { Router } from "express";


import { resendEmailCodeController, signupUserController, verifyEmailCodeController } from "../controllers/authentication/signup.controller";
import { authenticateToken } from "../middlewares/token.authentication";
import { changePasswordController, forgotPasswordController, loginUserController, postResetPasswordController } from "../controllers/authentication/login.controller";
import { logoutUserController } from "../controllers/authentication/logout.controller";
import { refreshAccessTokenController } from "../controllers/authentication/refresh.token.controller";
import { getCurrentUserController } from "../controllers/authentication/index.controller";

const router = Router();

router.post("/signup", signupUserController);
router.post("/resend-verification", authenticateToken, resendEmailCodeController);
router.post("/verify-code", authenticateToken, verifyEmailCodeController);

router.post("/login", loginUserController);
router.post("/logout", authenticateToken, logoutUserController);

router.post("/access-token", refreshAccessTokenController);

router.post("/change-password", authenticateToken, changePasswordController);

router.post("/forgot-password", forgotPasswordController);
router.post("/reset-password/:token", postResetPasswordController);

router.get("/current-user", authenticateToken, getCurrentUserController);

export default router;