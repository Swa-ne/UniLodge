import { Schema, Document, ObjectId, model } from 'mongoose';

export interface ImageSchemaInterface extends Document {
    _id: ObjectId,
    name: string,
    url: string,
    width?: number,
    height?: number,
}
const ImageSchema: Schema = new Schema({
    name: {
        type: String,
        required: true,
    },
    url: {
        type: String,
        required: true,
    },
    width: {
        type: String,
    },
    height: {
        type: String,
    },
});

export const Image = model<ImageSchemaInterface>("Image", ImageSchema)