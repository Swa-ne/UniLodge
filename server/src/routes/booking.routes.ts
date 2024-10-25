import { Router } from "express";
import { authenticateToken } from "../middlewares/token.authentication";
import { getBookingController, approveBookingController, rejectBookingController, createBookingController, getBookingsForListingController, checkIfBookedController, getbookingHistoryController, paidBookingController } from "../controllers/booking.controller";
//getAllBookingsController
const router = Router();

router.use(authenticateToken);

router.get("/get-booking/:bookingId", getBookingController);
router.put("/approve-booking/:bookingId", approveBookingController);
router.put("/reject-booking/:bookingId", rejectBookingController);
router.put("/pay-booking/:bookingId", paidBookingController);
router.post('/create-booking', authenticateToken, createBookingController);
router.get('/check-if-booked/:listingId', checkIfBookedController);
router.get('/booking-history', getbookingHistoryController);
// router.get('/all-bookings', getAllBookingsController);

router.get('/listings/bookings/:listingId', authenticateToken, getBookingsForListingController);

export default router;
