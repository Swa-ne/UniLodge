import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { postDormListingController } from "../controllers/listing.controller";

const router = Router();

router.use(authenticateToken);

router.post("/post-dorm", postDormListingController);

export default router;