import express from "express"
import { Server } from "socket.io";
import http from "http";

const app = express();

app.use(express.json())
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: process.env.CLIENT_URL,
        credentials: true,
    },
});

io.on("connection", (socket) => {
    console.log("a user connected", socket.id);
    socket.on("disconnect", () => {
        console.log("user disconnected", socket.id);
    });
});

export { app, io, server };