import express from "express"
import { Server } from "socket.io";
import http from "http";
import { ChangeUsersStatusToActive, ChangeUsersStatusToInactive, CheckUserStatusIfActive, getAllActiveUsers, GetSocketId } from "../services/chat.services";

const app = express();

app.use(express.json())
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: process.env.CLIENT_URL,
        credentials: true,
    },
});

io.on("connection", async (socket) => {
    const userId = socket.handshake.query.userId;
    try {
        const isActive = await CheckUserStatusIfActive(userId);

        if (!isActive) {
            await ChangeUsersStatusToActive(userId, socket.id);
        }
    } catch (error) {
        console.error("Error during user status check or update:", error);
    }

    io.to("online-users-room").emit("getOnlineUsers", await getAllActiveUsers());

    socket.on("send-msg", async (data) => {
        if (await CheckUserStatusIfActive(data.receiverId)) {

            const socketId = await GetSocketId(data.receiverId);
            if (socketId) socket.to(socketId).emit("msg-receive", { message: data.msg, chatId: data.chatId, senderId: data.senderId });
        }
    });

    socket.on("disconnect", async () => {
        await ChangeUsersStatusToInactive(userId);
        io.to("online-users-room").emit("getOnlineUsers", await getAllActiveUsers());
    });
});

export { app, io, server };