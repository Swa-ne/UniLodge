import { Booking } from "../models/booking/booking.model"; 
import { CustomResponse } from "../utils/input.validators";

export const getBookingById = async (bookingId: string): Promise<CustomResponse> => {
    try {
        const booking = await Booking.findById(bookingId).populate("user_id").exec();
        if (!booking) {
            return { error: 'Booking not found', httpCode: 404 };
        }
        return { message: booking.toObject(), httpCode: 200 };
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
