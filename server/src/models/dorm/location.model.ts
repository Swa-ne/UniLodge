import { Document, model, ObjectId, Schema } from "mongoose";

export interface LocationSchemaInterface extends Document {
    _id: ObjectId,
    city: string,
    street: string,
    barangay: string,
    house_number?: number,
    province: string,
    region: string,
    coordinates: {
        lat?: number,
        lng?: number,
    },
}


const LocationSchema: Schema = new Schema({
    region: {
        type: String,
        required: [true, 'Please enter region.'],
    },
    province: {
        type: String,
        required: [true, 'Please enter province.'],
    },
    city: {
        type: String,
        required: [true, 'Please enter city.'],
    },
    street: {
        type: String,
        required: [true, 'Please enter street.'],
    },
    barangay: {
        type: String,
        required: [true, 'Please enter barangay or district.'],
    },
    house_number: {
        type: String,
    },
    coordinates: {
        lat: {
            type: Number,
        },
        lng: {
            type: Number,
        },
    },
});

export const Location = model<LocationSchemaInterface>("Location", LocationSchema)