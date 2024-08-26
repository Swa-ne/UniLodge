import { Request, Response } from 'express';
import { UserType } from '../middlewares/token.authentication';
import { getDorms, postDormListing, putDormListing, toggleVisibilityDormListing } from '../services/listing.services';


export const getDormListingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const dorms = await getDorms(user.user_id);
        if (dorms.httpCode === 200) return res.status(dorms.httpCode).json({ 'message': dorms.message });
        return res.status(dorms.httpCode).json({ 'error': dorms.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }

}

export const postDormListingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });

        const { property_name, type, city, street, barangay_or_district, house_number, zip_code, lat, lng, currency_id, available_rooms, price_per_month, description, least_terms, rental_amenities, utility_included, image_urls, tags, } = req.body;

        const word_description = description.trim().split(/\s+/);
        if (word_description.length > 250) return res.status(413).json({ error: "Description contains too many words. Please shorten your description." });


        const requiredFields = {
            property_name,
            type,
            city,
            street,
            barangay_or_district,
            zip_code,
            currency_id,
            available_rooms,
            price_per_month,
            description,
            image_urls,
        };

        const updatedKey: { [key: string]: string } = {
            property_name: "Property Name",
            type: "Type",
            city: "City",
            street: "Street",
            barangay_or_district: "Barangay or District",
            zip_code: "Zip Code",
            currency_id: "Currency",
            available_rooms: "Available Room/s",
            price_per_month: "Price per Month",
            description: "Description",
            image_urls: "Image Urls",
        };

        for (const [key, value] of Object.entries(requiredFields)) {
            if (value == null) {
                return res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
            }
        }
        const dorm_post_update = await postDormListing(
            user.user_id,
            property_name,
            type,
            city,
            street,
            barangay_or_district,
            house_number,
            zip_code,
            lat,
            lng,
            currency_id,
            available_rooms,
            price_per_month,
            description,
            least_terms,
            rental_amenities,
            utility_included,
            image_urls,
            tags
        );
        if (dorm_post_update.httpCode === 200) return res.status(dorm_post_update.httpCode).json({ 'message': dorm_post_update.message });
        return res.status(dorm_post_update.httpCode).json({ 'error': dorm_post_update.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}

export const putDormListingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });
        const { dorm_id } = req.params;
        if (!dorm_id) return res.status(404).json({ error: "Dorm not found" });

        const { property_name, type, city, street, barangay_or_district, house_number, zip_code, lat, lng, currency_id, available_rooms, price_per_month, description, least_terms, rental_amenities, utility_included, image_urls, tags, } = req.body;

        const word_description = description.trim().split(/\s+/);
        if (word_description.length > 250) return res.status(413).json({ error: "Description contains too many words. Please shorten your description." });


        const requiredFields = {
            property_name,
            type,
            city,
            street,
            barangay_or_district,
            zip_code,
            currency_id,
            available_rooms,
            price_per_month,
            description,
            image_urls,
        };

        const updatedKey: { [key: string]: string } = {
            property_name: "Property Name",
            type: "Type",
            city: "City",
            street: "Street",
            barangay_or_district: "Barangay or District",
            zip_code: "Zip Code",
            currency_id: "Currency",
            available_rooms: "Available Room/s",
            price_per_month: "Price per Month",
            description: "Description",
            image_urls: "Image Urls",
        };

        for (const [key, value] of Object.entries(requiredFields)) {
            if (value == null) {
                return res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
            }
        }
        const dorm_put_update = await putDormListing(
            dorm_id,
            user.user_id,
            property_name,
            type,
            city,
            street,
            barangay_or_district,
            house_number,
            zip_code,
            lat,
            lng,
            currency_id,
            available_rooms,
            price_per_month,
            description,
            least_terms,
            rental_amenities,
            utility_included,
            image_urls,
            tags
        );

        if (dorm_put_update.httpCode === 200) return res.status(dorm_put_update.httpCode).json({ 'message': dorm_put_update.message });
        return res.status(dorm_put_update.httpCode).json({ 'error': dorm_put_update.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}
export const toggleVisibilityDormListingController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });
        const { dorm_id } = req.params;
        if (!dorm_id) return res.status(404).json({ error: "Dorm not found" });

        const dorm = await toggleVisibilityDormListing(dorm_id);
        if (dorm.httpCode === 200) return res.status(dorm.httpCode).json({ 'message': dorm.message });

        return res.status(dorm.httpCode).json({ 'error': dorm.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}