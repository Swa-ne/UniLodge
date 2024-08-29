import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getDormsController } from "../controllers/renter.controller";

const router = Router();

router.use(authenticateToken);

router.get("/my-dorms", getDormsController);

export default router;