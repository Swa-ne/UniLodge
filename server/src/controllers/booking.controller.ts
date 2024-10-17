import { Request, Response } from 'express';
import { UserType } from '../middlewares/token.authentication';
import { getBookingById, approveBooking, rejectBooking, createBooking } from '../services/booking.services'; 

export const getBookingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { bookingId } = req.params; 
        const booking = await getBookingById(bookingId);
        return res.status(booking.httpCode).json(booking.httpCode === 200 ? { message: booking.message } : { error: booking.error });
    } catch (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
    }
};


export const approveBookingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { bookingId } = req.params;
        const booking = await approveBooking(bookingId); 
        if (booking.httpCode === 200) {
            return res.status(booking.httpCode).json({ message: booking.message, booking });
        }

        return res.status(booking.httpCode).json({ error: booking.error });
    } catch (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
    }
};

export const rejectBookingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { bookingId } = req.params;
        const booking = await rejectBooking(bookingId);  
        if (booking.httpCode === 200) {
            return res.status(booking.httpCode).json({ message: booking.message, booking });
        }

        return res.status(booking.httpCode).json({ error: booking.error });
    } catch (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
    }
};


export const createBookingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
      const user = req.user;
      if (!user) return res.status(404).json({ error: "User not found" });
  
      const bookingData = req.body;
      const booking = await createBooking({ ...bookingData, user_id: user.user_id });
  
      return res.status(booking.httpCode).json(booking.httpCode === 201 ? { message: booking.message } : { error: booking.error });
    } catch (error) {
      return res.status(500).json({ error: 'Internal Server Error' });
    }
  };