import express, { Request, Response } from 'express';
import mongoose from 'mongoose';
import dotenv from "dotenv"
dotenv.config()

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

app.get('/', (req: Request, res: Response) => {
    res.send('Hello from your Node.js Express server!');
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});