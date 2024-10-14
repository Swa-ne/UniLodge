import { Request, Response } from "express";
import { UserType } from "../middlewares/token.authentication";
import {
  deleteDorm,
  getMyDorms,
  postDormListing,
  putDormListing,
  toggleVisibilityDormListing,
} from "../services/listing.services";
import {
  validateDescriptionLength,
  validateRequiredFields,
} from "../utils/input.validators";

const REQUIRED_FIELDS_LABELS = {
  property_name: "Property Name",
  type: "Type",
  city: "City",
  street: "Street",
  barangay: "Barangay or District",
  province: "Province",
  region: "Region",
  currency_id: "Currency",
  available_rooms: "Available Room/s",
  price: "Price per Month",
  description: "Description",
};

export const getMyDormsListingController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });

    const dorms = await getMyDorms(user.user_id);
    if (dorms.httpCode === 200)
      return res.status(dorms.httpCode).json({ message: dorms.message });
    return res.status(dorms.httpCode).json({ error: dorms.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const postDormListingController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });
    const {
      property_name,
      type,
      city,
      street,
      barangay,
      house_number,
      province,
      region,
      lat,
      lng,
      currency_id = "PHP",
      available_rooms = 1,
      price,
      description,
      least_terms,
      amenities,
      utilities,
      tags,
    } = req.body;

    if (!validateDescriptionLength(description)) {
      return res
        .status(413)
        .json({
          error:
            "Description contains too many words. Please shorten your description.",
        });
    }

    const { valid, error } = validateRequiredFields(
      {
        property_name,
        type,
        city,
        street,
        barangay,
        province,
        region,
        currency_id,
        available_rooms,
        price,
        description,
      },
      REQUIRED_FIELDS_LABELS
    );

    if (!valid) return res.status(400).json({ error });

    const image_files: Express.Multer.File[] | undefined = req.files as
      | Express.Multer.File[]
      | undefined;

    if (!image_files) {
      return res.status(400).json({ error: "No files uploaded" });
    }

    const dorm_post_update = await postDormListing(
      user.user_id,
      property_name,
      type,
      city,
      street,
      barangay,
      house_number,
      province,
      region,
      lat,
      lng,
      currency_id,
      available_rooms,
      price,
      description,
      least_terms,
      amenities,
      utilities,
      image_files,
      tags
    );
    if (dorm_post_update.httpCode === 200)
      return res
        .status(dorm_post_update.httpCode)
        .json({ message: dorm_post_update.message });
    return res
      .status(dorm_post_update.httpCode)
      .json({ error: dorm_post_update.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const putDormListingController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });

    const { dorm_id } = req.params;
    if (!dorm_id) return res.status(404).json({ error: "Dorm not found" });

    const {
      property_name,
      type,
      city,
      street,
      barangay,
      house_number,
      province,
      region,
      lat,
      lng,
      currency_id = "PHP",
      available_rooms = 1,
      price,
      description,
      least_terms,
      amenities,
      utilities,
      tags,
    } = req.body;

    if (!validateDescriptionLength(description)) {
      return res
        .status(413)
        .json({
          error:
            "Description contains too many words. Please shorten your description.",
        });
    }

    const image_files: Express.Multer.File[] | undefined = req.files as
      | Express.Multer.File[]
      | undefined;

    const { valid, error } = validateRequiredFields(
      {
        property_name,
        type,
        city,
        street,
        barangay,
        province,
        region,
        currency_id,
        available_rooms,
        price,
        description,
        image_files,
      },
      REQUIRED_FIELDS_LABELS
    );

    if (!valid) return res.status(400).json({ error });

    const dorm_put_update = await putDormListing(
      dorm_id,
      user.user_id,
      property_name,
      type,
      city,
      street,
      barangay,
      house_number,
      province,
      region,
      lat,
      lng,
      currency_id,
      available_rooms,
      price,
      description,
      least_terms,
      amenities,
      utilities,
      image_files,
      tags
    );
    if (dorm_put_update.httpCode === 200)
      return res
        .status(dorm_put_update.httpCode)
        .json({ message: dorm_put_update.message });
    return res
      .status(dorm_put_update.httpCode)
      .json({ error: dorm_put_update.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const toggleVisibilityDormListingController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });
    const { dorm_id } = req.params;
    if (!dorm_id) return res.status(404).json({ error: "Dorm not found" });

    const dorm = await toggleVisibilityDormListing(dorm_id);
    if (dorm.httpCode === 200)
      return res.status(dorm.httpCode).json({ message: dorm.message });

    return res.status(dorm.httpCode).json({ error: dorm.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const deleteDormController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });
    const { dorm_id } = req.params;
    if (!dorm_id) return res.status(404).json({ error: "Dorm not found" });

    const dorm = await deleteDorm(dorm_id);
    if (dorm.httpCode === 200)
      return res.status(dorm.httpCode).json({ message: dorm.message });

    return res.status(dorm.httpCode).json({ error: dorm.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
