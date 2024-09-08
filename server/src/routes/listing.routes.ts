import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getMyDormsListingController, postDormListingController, putDormListingController, toggleVisibilityDormListingController } from "../controllers/listing.controller";
import { uploadDorm } from "../middlewares/save.config";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getMyDormsListingController);
router.post("/post-dorm", uploadDorm.array('file'), postDormListingController);
router.put("/edit-dorm/:dorm_id", putDormListingController);
router.put("/toggle-visibility/:dorm_id", toggleVisibilityDormListingController);

export default router;