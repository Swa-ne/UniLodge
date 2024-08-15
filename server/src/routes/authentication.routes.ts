import { Router } from "express";


import { resendEmailCodeController, signupUserController, verifyEmailCodeController } from "../controllers/signup.controller";

const router = Router();

router.post("/signup", signupUserController);
router.post("/resend-verification", resendEmailCodeController);
router.post("/verify-code", verifyEmailCodeController);

export default router;