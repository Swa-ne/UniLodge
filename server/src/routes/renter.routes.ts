import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { deleteSavedDormController, getDormsController, postReviewController, putSavedDormController } from "../controllers/renter.controller";
import { saveDormLimiter } from "../middlewares/rate.limiter";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getDormsController);
router.post("/give-review/:dorm_id", postReviewController);
router.put("/add/saved", saveDormLimiter, putSavedDormController);
router.delete("/remove/saved", saveDormLimiter, deleteSavedDormController);

export default router;