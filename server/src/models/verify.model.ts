import { Document, model, ObjectId, Schema } from "mongoose";

export interface VerifyUserSchemaInterface extends Document {
    _id: ObjectId,
    name: string,
    user_id: string,
    type: string,
    url: string,
    width?: number,
    height?: number,
}

const VerifyUserSchema = new Schema<VerifyUserSchemaInterface>({
    name: {
        type: String,
        required: true,
    },
    user_id: {
        type: String,
        required: true,
    },
    type: {
        type: String,
        required: true,
    },
    url: {
        type: String,
        required: true,
    },
    width: {
        type: Number,
    },
    height: {
        type: Number,
    },
});

export const VerifyUser = model<VerifyUserSchemaInterface>("VerifyUser", VerifyUserSchema)