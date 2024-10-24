import express, { Request, Response } from 'express';
import mongoose from 'mongoose';
import bodyParser from "body-parser"
import cors from 'cors';
import cookieParser from 'cookie-parser';
import dotenv from "dotenv"
import { app, server } from './socket/socket.server';

dotenv.config()


import entryRoutes from "./routes/authentication.routes";
import chatRoutes from "./routes/chat.routes";
import dormRoutes from "./routes/dorm.routes";
import listingRoutes from "./routes/listing.routes";
import renterRoutes from "./routes/renter.routes";
import adminRoutes from "./routes/admin.routes";
import verifyRoutes from "./routes/verify.routes";
import bookingRoutes from "./routes/booking.routes";

const port = 3000;

const MONGODB_CONNECTION: any = process.env.MONGODB_CONNECTION;
mongoose
    .connect(MONGODB_CONNECTION)
    .then(() => {
        console.log('connected to MongoDB');
    })
    .catch((error) => {
        console.log('Internal Server Error');
    });

app.set('trust proxy', 1);

app.use(
    cors({
        origin: process.env.CLIENT_URL,
        credentials: true,
    })
);

app.use(express.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    }),
);
app.use(cookieParser())

app.use("/authentication", entryRoutes)
app.use("/chat", chatRoutes)
app.use("/dorm", dormRoutes)
app.use("/listing", listingRoutes)
app.use("/renter", renterRoutes)
app.use("/verify", verifyRoutes)
app.use("/admin", adminRoutes);
app.use("/booking", bookingRoutes);


app.get('/', (req: Request, res: Response) => {
    res.send('Hello from your Node.js Express server!');
});

server.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});