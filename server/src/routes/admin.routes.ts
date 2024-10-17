import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import {
  approveDormListingController,
  declineDormListingController,
  getDormsController,
} from "../controllers/admin.controller";

const router = Router();

router.use(authenticateToken);

router.get("/get-dorms", getDormsController);
router.put("/approve-listing/:dorm_id", approveDormListingController);
router.put("/decline-listing/:dorm_id", declineDormListingController);

export default router;
