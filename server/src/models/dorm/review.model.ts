import { Document, model, ObjectId, Schema } from "mongoose";

export interface ReviewSchemaInterface extends Document {
    _id: ObjectId,
    user_id: ObjectId,
    dorm_id: ObjectId,
    stars: number,
    comment?: string,
    createdAt?: Date,
    updatedAt?: Date,
}

const ReviewSchema = new Schema<ReviewSchemaInterface>({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    dorm_id: {
        type: Schema.Types.ObjectId,
        ref: 'Dorm',
    },
    stars: {
        type: Number,
        required: true
    },
    comment: {
        type: String
    },
}, {
    timestamps: true,
});

export const Review = model<ReviewSchemaInterface>("Review", ReviewSchema)