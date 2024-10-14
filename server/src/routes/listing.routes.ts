import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { deleteDormController, getMyDormsListingController, postDormListingController, putDormListingController, toggleVisibilityDormListingController, approveDormListingController, declineDormListingController } from "../controllers/listing.controller";
import { uploadDorm } from "../middlewares/save.config";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getMyDormsListingController);
router.post("/post-dorm", uploadDorm.array('file'), postDormListingController);
router.put("/edit-dorm/:dorm_id", uploadDorm.array('file'), putDormListingController);
router.put("/toggle-visibility/:dorm_id", toggleVisibilityDormListingController);
router.put(
  "/approve-listing/:dorm_id",
  approveDormListingController
);
router.put("/decline-listing/:dorm_id", declineDormListingController);
router.delete("/delete/:dorm_id", deleteDormController);

export default router;