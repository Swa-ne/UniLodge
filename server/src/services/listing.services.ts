import { Document, ObjectId, startSession } from 'mongoose';
import { CustomResponse } from '../utils/input.validators';
import { Dorm, DormSchemaInterface } from '../models/dorm/dorm.model';
import { Location, LocationSchemaInterface } from '../models/dorm/location.model';
import { getDownloadURL, ref, uploadBytesResumable } from 'firebase/storage';
import { storage } from '../middlewares/save.config';
import { Image } from '../models/media/image.model';

export const getMyDorms = async (user_id: string) => {
    try {
        const dorms: DormSchemaInterface[] | null = await Dorm.find({ owner_id: user_id });
        return { message: dorms, httpCode: 200 };
    } catch (error) {
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}

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
    image_files: Express.Multer.File[],
    tags: string[]
): Promise<CustomResponse> => {
    const session = await startSession();
    session.startTransaction();
    try {
        let image_urls: ObjectId[] = []
        if (image_files) {
            for (const file of image_files) {
                const storage_ref = ref(storage, `files/${file.originalname}${new Date()}`);

                const metadata = {
                    contentType: file.mimetype,
                };

                const snapshot = await uploadBytesResumable(storage_ref, file.buffer, metadata);
                const download_url = await getDownloadURL(snapshot.ref);

                const new_image = await new Image({
                    name: file.originalname,
                    url: download_url,
                }).save();

                image_urls.push(new_image._id);
            }
        }
        const latitude = parseFloat(lat);
        const longitude = parseFloat(lng);

        if (isNaN(latitude) || isNaN(longitude)) {
            return { error: 'Invalid latitude or longitude', httpCode: 400 };
        }

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

        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
};

export const putDormListing = async (
    dorm_id: string,
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
    try {
        const latitude = parseFloat(lat);
        const longitude = parseFloat(lng);

        if (isNaN(latitude) || isNaN(longitude)) {
            return { error: 'Invalid latitude or longitude', httpCode: 400 };
        }
        const dorm = await Dorm.findByIdAndUpdate(dorm_id, {
            owner_id: user_id,
            property_name,
            type,
            currency: currency_id,
            available_rooms,
            price_per_month,
            description,
            least_terms,
            rental_amenities,
            utility_included,
            image_urls,
            tags,
        }, { new: true });

        if (!dorm) {
            return { error: 'Dorm not found', httpCode: 404 };
        }

        await Location.findByIdAndUpdate(dorm.location, {
            city,
            street,
            barangay_or_district,
            house_number,
            zip_code,
            coordinates: {
                lat,
                lng,
            },
        });


        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        return { error: 'Internal Server Error', httpCode: 500 };
    }
};

export const toggleVisibilityDormListing = async (dorm_id: string): Promise<CustomResponse> => {
    try {
        const dorm = await Dorm.findById(dorm_id).exec();
        if (!dorm) {
            return { error: 'Dorm not found', httpCode: 404 };
        }
        dorm.isAvailable = !dorm.isAvailable;
        await dorm.save()

        return { message: "Success", httpCode: 200 }
    } catch (error) {
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}