import { Booking, BookingSchemaInterface } from "../models/booking/booking.model";
import { CustomResponse } from "../utils/input.validators";

export const getBookingById = async (bookingId: string) => {
  try {
    const booking = await Booking.findById(bookingId).populate("user_id").exec();
    if (!booking) {
      return { error: 'Booking not found', httpCode: 404 };
    }
    return { message: booking, httpCode: 200 };
  } catch (error) {
    return { error: "Internal Server Error", httpCode: 500 };
  }
};


export const approveBooking = async (bookingId: string): Promise<CustomResponse> => {
  try {
    const booking = await Booking.findById(bookingId).exec();
    if (!booking) {
      return { error: 'Booking not found', httpCode: 404 };
    }

    booking.status = 'Accepted';
    await booking.save();

    return { message: 'Booking accepted', httpCode: 200 };
  } catch (error) {
    return { error: "Internal Server Error", httpCode: 500 };
  }
};

export const rejectBooking = async (bookingId: string): Promise<CustomResponse> => {
  try {
    const booking = await Booking.findById(bookingId).exec();
    if (!booking) {
      return { error: 'Booking not found', httpCode: 404 };
    }

    booking.status = 'Rejected';
    await booking.save();

    return { message: 'Booking rejected', httpCode: 200 };
  } catch (error) {
    return { error: "Internal Server Error", httpCode: 500 };
  }
};

export const createBooking = async (bookingData: BookingSchemaInterface) => {
  try {
    const newBooking = new Booking(bookingData);
    await newBooking.save();

    return { message: newBooking, httpCode: 201 };
  } catch (error) {
    console.error("Error creating booking:", error);
    return { error: "Internal Server Error", httpCode: 500 };
  }

};

export const getBookingsForListing = async (listingId: string): Promise<CustomResponse> => {
  try {
    const bookings = await Booking.find({ listing_id: listingId }).populate("user_id").exec();
    return { message: bookings, httpCode: 200 };  // Now this works, because message can be an array
  } catch (error) {
    console.error("Error fetching bookings for listing:", error);
    return { error: "Internal Server Error", httpCode: 500 };
  }
};

export const getBookingHistory = async (user_id: string): Promise<CustomResponse> => {
  try {
    const bookings = await Booking.find({ user_id }).populate({
      path: "listing_id", populate: [{
        path: "owner_id",
        model: "User",
      }, {
        path: "location",
        model: "Location",
      }, {
        path: "imageUrl",
        model: "Image",
      }],
    }).exec();
    // const listings = bookings.map((booking) => booking.listing_id);
    console.log(bookings)
    return { message: bookings, httpCode: 200 };  // Now this works, because message can be an array
  } catch (error) {
    console.error("Error fetching bookings for listing:", error);
    return { error: "Internal Server Error", httpCode: 500 };
  }
};

export const checkIfBooked = async (user_id: string, listing_id: string): Promise<CustomResponse> => {
  try {
    const THIRTY_DAYS_AGO = new Date(new Date().setDate(new Date().getDate() - 30));
    const bookings = await Booking.find({
      $or: [
        {
          user_id,
          listing_id,
          status: { $in: ['Pending', 'Accepted'] },
        },
        {
          user_id,
          listing_id,
          createdAt: { $lt: THIRTY_DAYS_AGO },
        }
      ]
    }).exec();
    if (bookings.length > 0) {

      return { message: "Booked", httpCode: 200 };
    }
    return { message: "Nope", httpCode: 200 };
  } catch (error) {
    console.error("Error fetching bookings for listing:", error);
    return { error: "Internal Server Error", httpCode: 500 };
  }
};





//   export const getAllBookings = async (): Promise<CustomResponse> => {
//     try {
//         const bookings = await Booking.find().populate("user_id").exec();
//         if (!bookings || bookings.length === 0) {
//             return { error: 'No bookings found', httpCode: 404 };
//         }
//         return { message: bookings, httpCode: 200 };
//     } catch (error) {
//         console.error("Error fetching all bookings:", error);
//         return { error: "Internal Server Error", httpCode: 500 };
//     }
// };