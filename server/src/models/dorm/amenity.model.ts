import { Schema, Document, ObjectId, model } from 'mongoose';

export interface AmenitySchemaInterface extends Document {
    _id: ObjectId,
    name: string,
}
const AmenitySchema: Schema = new Schema({
    name: {
        type: String,
        required: true,
    },
});

export const Amenity = model<AmenitySchemaInterface>("Amenity", AmenitySchema)