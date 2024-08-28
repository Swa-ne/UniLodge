import { Document, model, ObjectId, Schema } from "mongoose";

export interface ImageSchemaInterface extends Document {
    _id: ObjectId,
    url: string,
    metadata?: {
        description?: string,
        width?: number,
        height?: number,
        format?: string,
    }
}

const ImageSchema = new Schema<ImageSchemaInterface>({
    url: {
        type: String,
        required: true
    },
    metadata: {
        description: {
            type: String
        },
        width: {
            type: Number
        },
        height: {
            type: Number
        },
        format: {
            type: String
        },
    }
});

export const Image = model<ImageSchemaInterface>("Image", ImageSchema)