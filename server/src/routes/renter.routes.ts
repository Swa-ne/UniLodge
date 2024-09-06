import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { deleteSavedDormController, getDormsController, postReviewController, putSavedDormController } from "../controllers/renter.controller";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getDormsController);
router.post("/give-review/:dorm_id", postReviewController);
router.put("/add/saved", putSavedDormController);
router.delete("/remove/saved", deleteSavedDormController);

export default router;