import { Request, Response } from "express";
import { createInbox, getAllInbox, getChatMessages, getInbox, getInboxDetails, getUserDetails, saveMessage } from "../services/chat.services";
import { UserType } from "../middlewares/token.authentication";
import { getAllActiveUsers } from "../services/chat.services";

export const getChatMessagesController = async (req: Request & { user?: UserType }, res: Response): Promise<Response<any, Record<string, any>>> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { user_id } = user;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        const result = await getAllActiveUsers(user_id)

        return res.status(200).json({ message: result });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const createPrivateInboxController = async (req: Request & { user?: UserType }, res: Response): Promise<Response<any, Record<string, any>>> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { user_id } = user;
        const { user_id2 } = req.body;
        if (!user_id && !user_id2) {
            return res.status(400).json({ error: 'User ID not provided' });
        }
        const result = await createInbox([user_id, user_id2 as string], false)

        return res.status(200).json({ message: result.message });
    } catch (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getInboxDetailsController = async (req: Request & { user?: UserType }, res: Response): Promise<Response<any, Record<string, any>>> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" })

        const { user_id } = user;
        const { chat_id } = req.params;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        if (!chat_id) {
            return res.status(400).json({ message: 'Chat ID not provided' });
        }
        const result = await getInboxDetails(chat_id as string, user_id)

        return res.status(200).json({ message: result.message });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};

export const saveMessageController = async (req: Request & { user?: UserType }, res: Response): Promise<Response<any, Record<string, any>>> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { user_id } = user;
        const { message, chat_id } = req.body;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        if (!chat_id) {
            return res.status(400).json({ message: 'Chat ID not provided' });
        }
        const result = await saveMessage(message, user_id, chat_id)

        return res.status(200).json({ message: result.message });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const getMessagesController = async (req: Request & { user?: UserType }, res: Response): Promise<Response<any, Record<string, any>>> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { user_id } = user;
        const { chat_id, page = 1 } = req.params;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        if (!chat_id) {
            return res.status(400).json({ message: 'Chat ID not provided' });
        }
        const result = await getChatMessages(chat_id as string, page as string)

        return res.status(200).json({ message: result });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const getUserDetailsController = async (req: Request & { user?: UserType }, res: Response): Promise<Response<any, Record<string, any>>> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });
        const { user_id } = user;
        const { chat_id } = req.params;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        if (!chat_id) {
            return res.status(400).json({ message: 'Chat ID not provided' });
        }
        const result = await getUserDetails(chat_id as string, user_id)
        return res.status(200).json({ message: result.message });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const getAllActiveUsersController = async (req: Request & { user?: UserType }, res: Response): Promise<any> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { user_id } = user;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        const result = await getAllActiveUsers(user_id)

        return res.status(200).json({ message: result });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const getInboxController = async (req: Request & { user?: UserType }, res: Response): Promise<any> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { user_id } = user;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        const result = await getInbox(user_id)
        return res.status(200).json({ message: result });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const getAllInboxController = async (req: Request & { user?: UserType }, res: Response): Promise<any> => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { user_id } = user;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        const result = await getAllInbox(user_id)
        return res.status(200).json({ message: result });
    } catch (error) {
        return res.status(500).json({ 'message': 'Internal Server Error' });
    }
};