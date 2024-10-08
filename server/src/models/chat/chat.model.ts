import { Schema, Document, ObjectId, model } from 'mongoose';
export interface ActiveUsersSchemeInterface extends Document {
    _id: string,
    userId: ObjectId,
    active: string,
    full_name: string,
}

const ActiveUsersScheme: Schema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    active: {
        type: String,
        required: [true, 'Please enter user status.'],
        default: "0"
    },
    fullName: {
        type: String
    }
})

export const ActiveUsers = model<ActiveUsersSchemeInterface>("ActiveUsers", ActiveUsersScheme)