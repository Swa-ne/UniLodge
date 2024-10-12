import { Types } from "mongoose";
import { User } from "../models/authentication/user.model";
import { ActiveUsers } from "../models/chat/chat.model";
import { Inbox } from "../models/chat/inbox.model";
import { Message } from "../models/chat/message.model";

export async function ChangeUsersStatusToActive(userId: any | undefined, socketId: string) {
    try {
        const result = await ActiveUsers.updateOne({ userId }, { $set: { active: socketId } })
        if (result.matchedCount === 0) {
            return false
        } else if (result.modifiedCount === 0) {
            return false
        }
        return true
    } catch (error) {
        console.error('Error updating user status on disconnect:', error);
        return false
    }
}
export async function ChangeUsersStatusToInactive(userId: any) {
    try {
        const result = await ActiveUsers.updateOne({ userId }, { $set: { active: 0 } })
        if (result.matchedCount === 0) {
            return false
        } else if (result.modifiedCount === 0) {
            return false
        }
        return true
    } catch (error) {
        console.error('Error updating user status on disconnect:', error);
        return false
    }
}
export async function CheckUserStatusIfActive(userId: any) {
    try {
        const result = await ActiveUsers.findOne({ userId })
        if (result?.active !== "0") {
            return true
        }
        return false
    } catch (error) {
        console.error('Error finding user status:', error);
        return false
    }
}
export async function GetSocketId(userId: any) {
    try {
        const result = await ActiveUsers.findOne({ userId })
        if (!result) {
            return false
        }
        if (result.active === "0") {
            return false
        }
        return result.active
    } catch (error) {
        console.error('Error finding user status:', error);
        return false
    }
}
export async function getAllActiveUsers(userId?: string) {
    try {
        const result = await ActiveUsers.find({ userId: { $ne: userId }, active: { $ne: "0" } })
        return result
    } catch {
        return "Internal server error"
    }
}
export async function getInbox(userId: string) {
    try {
        const user = await User.findById(userId).populate({
            path: 'inbox',
            match: { wasActive: true },
            options: { sort: { 'lastMessage': -1 } },
            populate: [
                {
                    path: 'lastMessage',
                    model: 'Message'
                },
                {
                    path: 'userIds',
                    model: 'ActiveUsers',
                    populate: {
                        path: "userId",
                        model: "User",
                    },
                },
            ]
        });
        if (!user) {
            return 'User not found';
        }
        return user.inbox;
    } catch (error) {
        console.error('Error fetching inbox:', error);
        throw error;
    }
}

export async function getChatMessages(chatId: string, page: string) {
    try {
        const result = await Message.find({ chatId })
            .sort({ createdAt: -1 })
            .skip((parseInt(page) - 1) * 30)
            .limit(30);
        return result
    } catch (error) {
        return { message: error, httpCode: 500 };
    }
}
export async function getUserDetails(chatId: string, userId: string) {
    try {
        const activeUserId = await ActiveUsers.findOne({ userId });
        const result = await Inbox.findById(chatId);

        if (result && result.userIds && activeUserId) {
            const activeUserIdString = activeUserId._id.toString();
            let receiver = result.userIds.filter(id => id.toString() !== activeUserIdString);
            const userDetails = await ActiveUsers.findById(receiver).populate("userId");

            return { message: userDetails?.userId, httpCode: 200 };
        }

        return { message: "Internal Server Error", httpCode: 500 };
    } catch (error) {
        return { message: error, httpCode: 500 };
    }
}
export async function saveMessage(message: string, senderId: string, chatId: string) {
    try {
        const msgId = await new Message({ message, senderId, chatId }).save()
        const inbox = await Inbox.findById(chatId)
        if (!inbox) {
            return { 'message': 'Inbox not found', "httpCode": 404 };
        }
        inbox.lastMessage = msgId._id;
        if (!inbox.wasActive) {
            inbox.wasActive = true
        }
        await inbox.save()
        return { 'message': 'Success', "httpCode": 200 };
    } catch (error) {
        return { message: error, httpCode: 500 };
    }
}
export async function createInbox(userIds: string[], isGroup: boolean, chatName?: string, profile?: string) {
    try {
        let activeUserIds: string[] = []
        const activeUsers = await ActiveUsers.find({ userId: { $in: userIds } });
        activeUserIds = activeUsers.map((activeUser) => activeUser._id.toString());
        const availableInbox = await inboxAvailable(activeUserIds, isGroup)
        if (!availableInbox) {
            const wasActive = isGroup
            const inbox = await new Inbox({ userIds: activeUserIds, chatName, profile, isGroup, wasActive }).save();
            await User.updateMany(
                { _id: { $in: userIds } },
                { $push: { inbox: inbox._id } }
            );
            return { 'message': inbox, "httpCode": 200 };
        }
        return { 'message': availableInbox, "httpCode": 200 };
    } catch (error) {
        return { message: error, httpCode: 500 };
    }
}
export async function inboxAvailable(userIds: string[], isGroup: boolean) {
    try {
        const objectIds = userIds.map((id: string) => new Types.ObjectId(id));

        const inbox = await Inbox.findOne({
            userIds: { $all: objectIds, $size: objectIds.length },
            isGroup
        }).populate({ path: "userIds", populate: "userId" });
        return inbox
    } catch (error) {
        return { message: error, httpCode: 500 };
    }
}
export async function getInboxDetails(chatId: string, currentUserId: string) {
    try {
        const details = await Inbox.findById(chatId).populate({ path: "userIds", populate: { path: "userId" } }).populate("lastMessage");
        if (!details) {
            return { message: 'Chat ID not found', httpCode: 404 }
        }
        const stringUserIds = details.userIds.filter(id => id.toString() !== currentUserId.toString())
        const activeDetails = await ActiveUsers.find({ _id: { $in: stringUserIds } })
        return { message: { ...details._doc }, httpCode: 200 }
    } catch (error) {
        return { message: error, httpCode: 500 };
    }
}
