import { startSession, Document, ObjectId } from "mongoose";
import { Dorm, DormSchemaInterface } from "../models/dorm/dorm.model";
import { CustomResponse } from "../utils/input.validators";
import { User } from "../models/authentication/user.model";

export const getDorms = async () => {
  try {
    const dorms: DormSchemaInterface[] | null = await Dorm.find()
      .populate("owner_id")
      .populate("location")
      .populate("currency")
      .populate("imageUrl");

    return { message: dorms, httpCode: 200 };
  } catch (error) {
    console.error("Error fetching dorms:", error);
    return { error: "Internal Server Error", httpCode: 500 };
  }
};

export const getUsers = async () => {
  try {
    const users = await User.find({
      $or: [
        { is_admin: false },
        { is_admin: { $exists: false } }
      ]
    });

    return { message: users, httpCode: 200 };
  } catch (error) {
    console.error("Error fetching users:", error);
    return { error: "Internal Server Error", httpCode: 500 };
  }
};
export const getUsersDorm = async (user_id: string) => {
  try {
    const dorms: DormSchemaInterface[] | null = await Dorm.find({ owner_id: user_id })
      .populate("owner_id")
      .populate("location")
      .populate("currency")
      .populate("imageUrl");
    return { message: dorms, httpCode: 200 };
  } catch (error) {
    console.error("Error fetching dorms:", error);
    return { error: "Internal Server Error", httpCode: 500 };
  }
};

export const approveDormListing = async (
  dorm_id: string
): Promise<CustomResponse> => {
  try {
    const dorm = await Dorm.findById(dorm_id).exec();
    if (!dorm) {
      return { error: "Dorm not found", httpCode: 404 };
    }
    dorm.status = "Approved";
    await dorm.save();

    return { message: "Success", httpCode: 200 };
  } catch (error) {
    return { error: "Internal Server Error", httpCode: 500 };
  }
};

export const declineDormListing = async (
  dorm_id: string
): Promise<CustomResponse> => {
  try {
    const dorm = await Dorm.findById(dorm_id).exec();
    if (!dorm) {
      return { error: "Dorm not found", httpCode: 404 };
    }
    dorm.status = "Declined";
    await dorm.save();

    return { message: "Success", httpCode: 200 };
  } catch (error) {
    return { error: "Internal Server Error", httpCode: 500 };
  }
};