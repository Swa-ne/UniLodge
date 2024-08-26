import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getDormListingController, postDormListingController, putDormListingController } from "../controllers/listing.controller";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getDormListingController);
router.post("/post-dorm", postDormListingController);
router.put("/edit-dorm/:post_id", putDormListingController);

export default router;