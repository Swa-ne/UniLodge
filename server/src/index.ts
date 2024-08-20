import express, { Request, Response } from 'express';
import mongoose from 'mongoose';
import bodyParser from "body-parser"
import cors from 'cors';
import cookieParser from 'cookie-parser';
import dotenv from "dotenv"
dotenv.config()


import entryRoutes from "./routes/authentication.routes";

const app = express();

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

app.get('/', (req: Request, res: Response) => {
    res.send('Hello from your Node.js Express server!');
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});