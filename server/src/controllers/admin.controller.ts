import { Request, Response } from "express";
import { UserType } from "../middlewares/token.authentication";
import {
  approveDormListing,
  declineDormListing,
  getDorms,
  getUsers,
  getUsersDorm,
} from "../services/admin.services";
import {
  validateDescriptionLength,
  validateRequiredFields,
} from "../utils/input.validators";



export const getDormsController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });
    const { user_id } = user;
    if (!user_id) {
      return res.status(400).json({ message: "User ID not provided" });
    }
    const dorms = await getDorms();
    if (dorms.httpCode === 200)
      return res.status(dorms.httpCode).json({ message: dorms.message });
    return res.status(dorms.httpCode).json({ error: dorms.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const getUsersController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });

    const users = await getUsers();
    if (users.httpCode === 200)
      return res.status(users.httpCode).json({ message: users.message });
    return res.status(users.httpCode).json({ error: users.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const getUsersDormController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });
    const { user_id } = req.params;
    if (!user_id) {
      return res.status(400).json({ message: "User ID not provided" });
    }
    const dorms = await getUsersDorm(user_id);
    if (dorms.httpCode === 200)
      return res.status(dorms.httpCode).json({ message: dorms.message });
    return res.status(dorms.httpCode).json({ error: dorms.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const approveDormListingController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });
    const { dorm_id } = req.params;
    if (!dorm_id) return res.status(404).json({ error: "Dorm not found" });

    const dorm = await approveDormListing(dorm_id);
    if (dorm.httpCode === 200)
      return res.status(dorm.httpCode).json({ message: dorm.message });

    return res.status(dorm.httpCode).json({ error: dorm.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const declineDormListingController = async (
  req: Request & { user?: UserType },
  res: Response
) => {
  try {
    const user = req.user;
    if (!user) return res.status(404).json({ error: "User not found" });
    const { dorm_id } = req.params;
    if (!dorm_id) return res.status(404).json({ error: "Dorm not found" });

    const dorm = await declineDormListing(dorm_id);
    if (dorm.httpCode === 200)
      return res.status(dorm.httpCode).json({ message: dorm.message });

    return res.status(dorm.httpCode).json({ error: dorm.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
