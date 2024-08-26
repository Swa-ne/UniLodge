import mongoose, { Schema, Document, ObjectId } from 'mongoose';

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
    createdAt?: Date,
    updatedAt?: Date,
}

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

export interface AmenitySchemaInterface extends Document {
    _id: ObjectId,
    name: string,
}

export interface UtilitySchemaInterface extends Document {
    _id: ObjectId,
    name: string,
}

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

export interface CurrencySchemaInterface extends Document {
    _id: ObjectId,
    code: string,
    symbol: string,
}

const DormSchema: Schema = new Schema({
    owner_id: {
        type: mongoose.Types.ObjectId,
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
        type: mongoose.Types.ObjectId,
        required: true,
        ref: 'Location',
    },
    currency: {
        type: mongoose.Types.ObjectId,
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
        type: mongoose.Types.ObjectId,
        ref: 'Amenity',
    }],
    utility_included: [{
        type: mongoose.Types.ObjectId,
        ref: 'Utility',
    }],
    image_urls: [{
        type: mongoose.Types.ObjectId,
        required: [true, 'Please include atleast one image.'],
        ref: 'Utility',
    }],
    tags: [{
        type: String,
    }],
}, {
    timestamps: true,
});

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

const AmenitySchema: Schema = new Schema({
    name: {
        type: String,
        required: true,
    },
});

const UtilitySchema: Schema = new Schema({
    name: {
        type: String,
        required: true,
    },
});

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

const CurrencySchema: Schema = new Schema({
    code: {
        type: String,
        required: true,
    },
    symbol: {
        type: String,
        required: true,
    },
});

export const Dorm = mongoose.model<DormSchemaInterface>("User", DormSchema)
export const Location = mongoose.model<LocationSchemaInterface>("Location", LocationSchema)
export const Amenity = mongoose.model<AmenitySchemaInterface>("Amenity", AmenitySchema)
export const Utility = mongoose.model<UtilitySchemaInterface>("Utility", UtilitySchema)
export const Image = mongoose.model<ImageSchemaInterface>("Image", ImageSchema)
export const Currency = mongoose.model<CurrencySchemaInterface>("Currency", CurrencySchema)
