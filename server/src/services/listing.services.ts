import { Document, ObjectId, startSession } from 'mongoose';
import { CustomResponse } from '../utils/input.validators';
import { Dorm, DormSchemaInterface } from '../models/dorm/dorm.model';
import { Location, LocationSchemaInterface } from '../models/dorm/location.model';
import { getDownloadURL, ref, uploadBytesResumable } from 'firebase/storage';
import { deleteImage, storage } from '../middlewares/save.config';
import { Image } from '../models/media/image.model';
import { Currency } from '../models/dorm/currency.model';

export const getMyDorms = async (user_id: string) => {
    try {
        const dorms: DormSchemaInterface[] | null = await Dorm.find({ owner_id: user_id })
            .populate('owner_id')
            .populate('location')
            .populate('currency')
            .populate('imageUrl');
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
    barangay: string,
    house_number: string,
    province: string,
    region: string,
    lat: string,
    lng: string,
    currency_id: string,
    available_rooms: string,
    price: string,
    description: string,
    least_terms: string,
    amenities: string[],
    utilities: string[],
    image_files: Express.Multer.File[],
    tags: string[]
): Promise<CustomResponse> => {
    const session = await startSession();
    session.startTransaction();
    try {
        let imageUrl: ObjectId[] = []

        console.log("saving images to database")
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

                imageUrl.push(new_image._id);
            }
        }

        console.log("images are now saved into the database")
        // TODO: update this if map is already integrated
        const latitude = parseFloat("0");
        const longitude = parseFloat("0");

        if (isNaN(latitude) || isNaN(longitude)) {
            return { error: 'Invalid latitude or longitude', httpCode: 400 };
        }

        const newLoc: Document<unknown, {}, LocationSchemaInterface> & LocationSchemaInterface & Required<{ _id: ObjectId; }> | null = await new Location({
            city,
            street,
            barangay,
            house_number,
            province,
            region,
            coordinates: {
                lat,
                lng,
            },
        }).save({ session });

        console.log("location has been saved")
        const currency = await Currency.findById("67055ace8fbd824752301b4b");

        await new Dorm({
            owner_id: user_id,
            property_name,
            type,
            location: newLoc._id,
            currency: currency!._id ?? "currency",
            available_rooms,
            price,
            description,
            least_terms,
            amenities,
            utilities,
            imageUrl,
            tags,
        }).save({ session });

        console.log("dorm has been saved")
        await session.commitTransaction();
        session.endSession();
        console.log("dorm posting complete")
        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        console.log(error)
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
    barangay: string,
    house_number: string,
    province: string,
    region: string,
    lat: string,
    lng: string,
    currency_id: string,
    available_rooms: string,
    price: string,
    description: string,
    least_terms: string,
    amenities: string[],
    utilities: string[],
    image_files: Express.Multer.File[],
    tags: string[]
): Promise<CustomResponse> => {
    try {
        const existingDorm = await Dorm.findById(dorm_id).populate("imageUrl");

        if (!existingDorm) {
            return { error: 'Dorm not found', httpCode: 404 };
        }

        if (existingDorm.imageUrl.length > 0) {
            for (const image of existingDorm.imageUrl) {
                try {
                    if (typeof image === 'object' && 'url' in image) {
                        await deleteImage(image.url);
                        await Image.findByIdAndDelete(image._id);
                    }
                } catch (err) {
                    console.error(`Error deleting image ${image}:`, err);
                }
            }
        }

        let imageUrl: ObjectId[] = []
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

                imageUrl.push(new_image._id);
            }
        }

        // TODO: update this if map is already integrated
        const latitude = parseFloat("0");
        const longitude = parseFloat("0");

        if (isNaN(latitude) || isNaN(longitude)) {
            return { error: 'Invalid latitude or longitude', httpCode: 400 };
        }

        const dorm = await Dorm.findByIdAndUpdate(dorm_id, {
            owner_id: user_id,
            property_name,
            type,
            currency: currency_id,
            available_rooms,
            price,
            description,
            least_terms,
            amenities,
            utilities,
            imageUrl,
            tags,
        }, { new: true });

        if (!dorm) {
            return { error: 'Dorm not found', httpCode: 404 };
        }

        await Location.findByIdAndUpdate(dorm.location, {
            city,
            street,
            barangay,
            house_number,
            province,
            region,
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

export const deleteDorm = async (dorm_id: string): Promise<CustomResponse> => {
    try {
        const dorm = await Dorm.findByIdAndDelete(dorm_id);
        if (!dorm) {
            return { error: 'Dorm not found', httpCode: 404 };
        }

        return { message: "Success", httpCode: 200 }
    } catch (error) {
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}