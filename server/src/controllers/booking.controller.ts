import { Request, Response } from 'express';
import { UserType } from '../middlewares/token.authentication';
import { getBookingById, approveBooking, rejectBooking, createBooking, getBookingsForListing, checkIfBooked, getBookingHistory, paidBooking, } from '../services/booking.services';

// Get booking by ID controller
export const getBookingController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const { bookingId } = req.params;
    if (!bookingId) return res.status(400).json({ error: "Bad Request: Booking ID is required." });

    const booking = await getBookingById(bookingId);

    if (booking.httpCode === 200) {
      return res.status(200).json({ message: booking.message });
    } else {
      return res.status(booking.httpCode).json({ error: booking.error });
    }
  } catch (error) {
    console.error("Error fetching booking:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

// Approve booking controller
export const approveBookingController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const { bookingId } = req.params;
    if (!bookingId) return res.status(400).json({ error: "Bad Request: Booking ID is required." });

    const booking = await approveBooking(bookingId);

    if (booking.httpCode === 200) {
      return res.status(200).json({ message: booking.message, booking });
    } else {
      return res.status(booking.httpCode).json({ error: booking.error });
    }
  } catch (error) {
    console.error("Error approving booking:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

// Reject booking controller
export const rejectBookingController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const { bookingId } = req.params;
    if (!bookingId) return res.status(400).json({ error: "Bad Request: Booking ID is required." });

    const booking = await rejectBooking(bookingId);

    if (booking.httpCode === 200) {
      return res.status(200).json({ message: booking.message, booking });
    } else {
      return res.status(booking.httpCode).json({ error: booking.error });
    }
  } catch (error) {
    console.error("Error rejecting booking:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

export const paidBookingController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const { bookingId } = req.params;
    if (!bookingId) return res.status(400).json({ error: "Bad Request: Booking ID is required." });

    const booking = await paidBooking(bookingId);

    if (booking.httpCode === 200) {
      return res.status(200).json({ message: booking.message, booking });
    } else {
      return res.status(booking.httpCode).json({ error: booking.error });
    }
  } catch (error) {
    console.error("Error paid booking:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

// Create booking controller
// export const createBookingController = async (req: Request & { user?: UserType }, res: Response) => {
//     try {
//         const user = req.user;
//         if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

//         const bookingData = req.body;
//         if (!bookingData) return res.status(400).json({ error: "Bad Request: Booking data is required." });

//         const booking = await createBooking({ ...bookingData, user_id: user.user_id });

//         if (booking.httpCode === 201) {
//             return res.status(201).json({ message: booking.message });
//         } else {
//             return res.status(booking.httpCode).json({ error: booking.error });
//         }
//     } catch (error) {
//         console.error("Error creating booking:", error);
//         return res.status(500).json({ error: 'Internal Server Error' });
//     }
// };
export const createBookingController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const bookingData = req.body;
    if (!bookingData.listing_id) return res.status(400).json({ error: "Bad Request: listing_id is required." });

    const booking = await createBooking({ ...bookingData, user_id: user.user_id });

    if (booking.httpCode === 201) {
      return res.status(201).json({ message: booking.message });
    } else {
      return res.status(booking.httpCode).json({ error: booking.error });
    }
  } catch (error) {
    console.error("Error creating booking:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

export const getBookingsForListingController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const { listingId } = req.params;
    if (!listingId) return res.status(400).json({ error: "Bad Request: Listing ID is required." });

    const bookings = await getBookingsForListing(listingId);

    if (bookings.httpCode === 200) {
      return res.status(200).json({ message: bookings.message });  // Will now handle array or string
    } else {
      return res.status(bookings.httpCode).json({ error: bookings.error });
    }
  } catch (error) {
    console.error("Error fetching bookings for listing:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

export const checkIfBookedController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const { user_id } = user;
    if (!user_id) return res.status(400).json({ message: "User ID not provided" });

    const { listingId } = req.params;
    if (!listingId) return res.status(400).json({ error: "Bad Request: Listing ID is required." });

    const bookings = await checkIfBooked(user_id, listingId);

    if (bookings.httpCode === 200) {
      return res.status(200).json({ message: bookings.message });  // Will now handle array or string
    } else {
      return res.status(bookings.httpCode).json({ error: bookings.error });
    }
  } catch (error) {
    console.error("Error fetching bookings for listing:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
}
export const getbookingHistoryController = async (req: Request & { user?: UserType }, res: Response) => {
  try {
    const user = req.user;
    if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

    const { user_id } = user;
    if (!user_id) return res.status(400).json({ message: "User ID not provided" });

    const bookings = await getBookingHistory(user_id);

    if (bookings.httpCode === 200) {
      return res.status(200).json({ message: bookings.message });  // Will now handle array or string
    } else {
      return res.status(bookings.httpCode).json({ error: bookings.error });
    }
  } catch (error) {
    console.error("Error fetching bookings for listing:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
}

// export const getAllBookingsController = async (req: Request & { user?: UserType }, res: Response) => {
//     try {
//         const user = req.user;
//         if (!user) return res.status(401).json({ error: "Unauthorized: User not found." });

//         const bookings = await getAllBookings();

//         if (bookings.httpCode === 200) {
//             return res.status(200).json({ message: bookings.message });
//         } else {
//             return res.status(bookings.httpCode).json({ error: bookings.error });
//         }
//     } catch (error) {
//         console.error("Error fetching all bookings:", error);
//         return res.status(500).json({ error: 'Internal Server Error' });
//     }
// };