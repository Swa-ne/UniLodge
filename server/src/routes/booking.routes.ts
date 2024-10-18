import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getBookingController, approveBookingController, rejectBookingController, createBookingController, getBookingsForListingController  } from "../controllers/booking.controller";
//getAllBookingsController
const router = Router();

router.use(authenticateToken);

router.get("/get-booking/:bookingId", getBookingController);
router.put("/approve-booking/:bookingId", approveBookingController);
router.put("/reject-booking/:bookingId", rejectBookingController);
router.post('/create-booking', authenticateToken, createBookingController);
// router.get('/all-bookings', getAllBookingsController);

router.get('/listings/:listingId/bookings', authenticateToken, getBookingsForListingController);

export default router;
