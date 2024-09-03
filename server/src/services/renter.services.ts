import { Document, ObjectId, startSession } from 'mongoose';
import { CustomResponse } from '../utils/input.validators';
import { Dorm, DormSchemaInterface } from '../models/dorm/dorm.model';
import { Review } from '../models/dorm/review.model';

export const getDorms = async () => {
    try {
        const dorms: DormSchemaInterface[] | null = await Dorm.find();
        return { message: dorms, httpCode: 200 };
    } catch (error) {
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}

export const postReviewForDorm = async (user_id: string, dorm_id: string, stars: number, comment: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        await new Review({
            user_id,
            dorm_id,
            stars,
            comment
        })
        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}