import { Schema, Document, ObjectId, model } from 'mongoose';

export interface DormSchemaInterface extends Document {
    _id: ObjectId,
    owner_id: ObjectId,
    property_name: string,
    type: string,
    location: ObjectId,
    currency: ObjectId,
    available_rooms: number,
    price_per_month: number,
    description: string,
    least_terms?: string,
    rental_amenities?: ObjectId[],
    utility_included?: ObjectId[],
    image_urls: ObjectId[],
    tags?: string[],
    isAvailable: boolean,
    createdAt?: Date,
    updatedAt?: Date,
}

const DormSchema: Schema = new Schema({
    owner_id: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'User',
    },
    property_name: {
        type: String,
        required: [true, 'Please enter property name.'],
    },
    type: {
        type: String,
        required: [true, 'Please enter property name.'],
    },
    location: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'Location',
    },
    currency: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'Currency',
    },
    available_rooms: {
        type: Number,
        default: 0,
        required: [true, 'Please enter available rooms.'],
    },
    price_per_month: {
        type: Number,
        default: 0,
        required: [true, 'Please enter price.'],
    },
    description: {
        type: String,
        required: [true, 'Please enter description.'],
    },
    least_terms: {
        type: String,
    },
    rental_amenities: [{
        type: Schema.Types.ObjectId,
        ref: 'Amenity',
    }],
    utility_included: [{
        type: Schema.Types.ObjectId,
        ref: 'Utility',
    }],
    image_urls: [{
        type: Schema.Types.ObjectId,
        required: [true, 'Please include atleast one image.'],
        ref: 'Utility',
    }],
    tags: [{
        type: String,
    }],
    isAvailable: {
        type: Boolean,
        default: true
    },
}, {
    timestamps: true,
});

export const Dorm = model<DormSchemaInterface>("Dorm", DormSchema)