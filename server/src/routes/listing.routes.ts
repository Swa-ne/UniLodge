import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { deleteDormController, getMyDormsListingController, isValidLandlordController, postDormListingController, putDormListingController, toggleVisibilityDormListingController } from "../controllers/listing.controller";
import { uploadDorm } from "../middlewares/save.config";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getMyDormsListingController);
router.get("/is-valid-landlord", isValidLandlordController);
router.post("/post-dorm", uploadDorm.array('file'), postDormListingController);
router.put("/edit-dorm/:dorm_id", uploadDorm.array('file'), putDormListingController);
router.put("/toggle-visibility/:dorm_id", toggleVisibilityDormListingController);
router.delete("/delete/:dorm_id", deleteDormController);

export default router;