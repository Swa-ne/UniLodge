import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import {
  approveDormListingController,
  declineDormListingController,
  getDormsController,
  getUsersController,
  getUsersDormController,
} from "../controllers/admin.controller";

const router = Router();

router.use(authenticateToken);

router.get("/get-dorms", getDormsController);
router.get("/get-users", getUsersController);
router.get("/get-dorms/:user_id", getUsersDormController);
router.put("/suspend/:user_id", getUsersController);
router.put("/approve-listing/:dorm_id", approveDormListingController);
router.put("/decline-listing/:dorm_id", declineDormListingController);

export default router;
