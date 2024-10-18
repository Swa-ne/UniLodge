import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getBookingController, approveBookingController, rejectBookingController } from "../controllers/booking.controller";

const router = Router();

router.use(authenticateToken);

router.get("/get-booking/:bookingId", getBookingController);
router.put("/approve-booking/:bookingId", approveBookingController);
router.put("/reject-booking/:bookingId", rejectBookingController);

export default router;
