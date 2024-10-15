import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { uploadDorm } from "../middlewares/save.config";
import { verifyFaceImageController, verifyIDImageController, verifyUserController } from "../controllers/verify.contoller";

const router = Router();

router.use(authenticateToken);

router.post("/check-face", uploadDorm.single('file'), verifyFaceImageController);
router.post("/check-id", uploadDorm.single('file'), verifyIDImageController);
router.post("/verify-user", verifyUserController);

export default router;