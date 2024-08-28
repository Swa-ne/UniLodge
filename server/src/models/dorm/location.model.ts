import { Document, model, ObjectId, Schema } from "mongoose";

export interface LocationSchemaInterface extends Document {
    _id: ObjectId,
    city: string,
    street: string,
    barangay_or_district: string,
    house_number?: number,
    zip_code: number,
    coordinates: {
        lat?: number,
        lng?: number,
    },
}


const LocationSchema: Schema = new Schema({
    city: {
        type: String,
        required: [true, 'Please enter city.'],
    },
    street: {
        type: String,
        required: [true, 'Please enter street.'],
    },
    barangay_or_district: {
        type: String,
        required: [true, 'Please enter barangay or district.'],
    },
    house_number: {
        type: String,
    },
    zip_code: {
        type: Number,
        required: [true, 'Please enter zip code.'],
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