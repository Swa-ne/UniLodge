import { Schema, Document, ObjectId, model } from 'mongoose';

export interface UtilitySchemaInterface extends Document {
    _id: ObjectId,
    name: string,
}

const UtilitySchema: Schema = new Schema({
    name: {
        type: String,
        required: true,
    },
});

export const Utility = model<UtilitySchemaInterface>("Utility", UtilitySchema)