import mongoose, { Schema, Document, ObjectId } from 'mongoose';


export interface InboxSchemeInterface extends Document {
    userIds: ObjectId[],
    chatName?: string,
    profile?: string,
    isGroup: boolean,
    wasActive: boolean,
    lastMessage: ObjectId,
}

const InboxScheme: Schema = new Schema({
    userIds: [{
        type: Schema.Types.ObjectId,
        ref: 'ActiveUsers',
    }],
    chatName: {
        type: String,
        default: ""
    },
    profile: {
        type: String,
        default: "https://i.pinimg.com/originals/58/51/2e/58512eb4e598b5ea4e2414e3c115bef9.jpg"
    },
    isGroup: {
        type: Boolean,
        required: [true, 'Please enter if this group chat.'],
    },
    wasActive: {
        type: Boolean,
        default: false
    },
    lastMessage: {
        type: Schema.Types.ObjectId,
        ref: 'Message'
    }
}, {
    timestamps: true,
})

export const Inbox = mongoose.model<InboxSchemeInterface>("Inbox", InboxScheme)