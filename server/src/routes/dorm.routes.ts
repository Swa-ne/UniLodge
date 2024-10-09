import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getDormContoller } from "../controllers/dorm.contoller";

const router = Router();

router.use(authenticateToken);

router.get("/dorm/:id", getDormContoller);

export default router;