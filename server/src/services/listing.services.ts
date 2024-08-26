import { Document, ObjectId, startSession } from 'mongoose';
import { CustomResponse } from '../utils/input.validators';
import { Dorm, Location, LocationSchemaInterface } from '../models/dorm.model';

export const postDormListing = async (
    user_id: string,
    property_name: string,
    type: string,
    city: string,
    street: string,
    barangay_or_district: string,
    house_number: string,
    zip_code: string,
    lat: string,
    lng: string,
    currency_id: string,
    available_rooms: string,
    price_per_month: string,
    description: string,
    least_terms: string,
    rental_amenities: string[],
    utility_included: string[],
    image_urls: string[],
    tags: string[]
): Promise<CustomResponse> => {
    const session = await startSession();
    session.startTransaction();

    try {
        const newLoc: Document<unknown, {}, LocationSchemaInterface> & LocationSchemaInterface & Required<{ _id: ObjectId; }> | null = await new Location({
            city,
            street,
            barangay_or_district,
            house_number,
            zip_code,
            coordinates: {
                lat,
                lng,
            },
        }).save({ session });

        await new Dorm({
            owner_id: user_id,
            property_name,
            type,
            location: newLoc._id,
            currency: currency_id,
            available_rooms,
            price_per_month,
            description,
            least_terms,
            rental_amenities,
            utility_included,
            image_urls,
            tags,
        }).save({ session });

        await session.commitTransaction();
        session.endSession();

        return { message: 'Success', httpCode: 500 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
};
