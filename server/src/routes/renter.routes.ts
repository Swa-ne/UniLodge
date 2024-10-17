import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import {
  deleteSavedDormController,
  getDormsController,
  getSavedDormsController,
  postReviewController,
  putSavedDormController,
} from "../controllers/renter.controller";
import { saveDormLimiter } from "../middlewares/rate.limiter";

const router = Router();

router.use(authenticateToken);

router.get("/get-dorms", getDormsController);
router.get("/saved-dorms", getSavedDormsController);
router.post("/give-review/:dorm_id", postReviewController);
router.put("/add/saved/:dorm_id", saveDormLimiter, putSavedDormController);
router.delete(
  "/remove/saved/:dorm_id",
  saveDormLimiter,
  deleteSavedDormController
);

export default router;
