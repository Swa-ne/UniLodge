import { Schema, Document, ObjectId, model } from 'mongoose';
import { Image, ImageSchemaInterface } from './image.model';

export interface DormSchemaInterface extends Document {
    _id: ObjectId,
    owner_id: ObjectId,
    property_name: string,
    type: string,
    location: ObjectId,
    currency: ObjectId,
    available_rooms: number,
    price: number,
    description: string,
    least_terms?: string,
    amenities?: string[],
    utilities?: string[],
    imageUrl: ObjectId[] | ImageSchemaInterface[],
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
    price: {
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
    amenities: [{
        type: String,
    }],
    utilities: [{
        type: String,
    }],
    imageUrl: [{
        type: Schema.Types.ObjectId,
        ref: 'Image',
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