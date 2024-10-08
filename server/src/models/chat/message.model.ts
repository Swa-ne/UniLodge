import mongoose, { Schema, Document, ObjectId } from 'mongoose';

export interface MessageProps {
    _id: ObjectId,
    message: string,
    senderId: ObjectId,
    chatId: ObjectId,
    isRead: boolean
}

const MessageScheme: Schema = new Schema({
    message: {
        type: String,
        required: [true, 'Please enter Message.'],
    },
    senderId: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    chatId: {
        type: Schema.Types.ObjectId,
        ref: 'Inbox',
    },
    isRead: {
        type: Boolean,
        default: false
    },
}, {
    timestamps: true,
})

export const Message = mongoose.model<MessageProps>("Message", MessageScheme)