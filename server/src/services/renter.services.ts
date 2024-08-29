import { Document, ObjectId, startSession } from 'mongoose';
import { CustomResponse } from '../utils/input.validators';
import { Dorm, DormSchemaInterface } from '../models/dorm/dorm.model';

export const getDorms = async () => {
    try {
        const dorms: DormSchemaInterface[] | null = await Dorm.find();
        return { message: dorms, httpCode: 200 };
    } catch (error) {
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}