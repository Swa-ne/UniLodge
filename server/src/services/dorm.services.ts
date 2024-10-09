import { Dorm } from "../models/dorm/dorm.model";
import { CustomResponse } from "../utils/input.validators";

export const getDorm = async (dorm_id: string) => {
    try {
        const dorm = await Dorm.findById(dorm_id).exec();
        if (!dorm) {
            return { error: 'User not found', httpCode: 404 };
        }
        return { message: dorm, httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
};
