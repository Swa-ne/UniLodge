import { Document, model, ObjectId, Schema } from "mongoose";

export interface SavedSchemaInterface extends Document {
    _id: ObjectId,
    user_id: ObjectId,
    dorm_ids: ObjectId[],
    createdAt?: Date,
    updatedAt?: Date,
}

const SavedSchema = new Schema<SavedSchemaInterface>({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    dorm_ids: [
        {
            type: Schema.Types.ObjectId,
            ref: 'Dorm',
        },
    ],
}, {
    timestamps: true,
});

export const Saved = model<SavedSchemaInterface>("Saved", SavedSchema)