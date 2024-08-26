import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getDormListingController, postDormListingController } from "../controllers/listing.controller";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getDormListingController);
router.post("/post-dorm", postDormListingController);

export default router;