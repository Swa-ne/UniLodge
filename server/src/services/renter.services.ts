import { startSession, Document } from 'mongoose';
import { Dorm, DormSchemaInterface } from '../models/dorm/dorm.model';
import { Review } from '../models/dorm/review.model';
import { Saved, SavedSchemaInterface } from '../models/dorm/saved.model';

export const getDorms = async (user_id: string) => {
    try {
        const dorms: DormSchemaInterface[] | null = await Dorm.find({
            owner_id: { $ne: user_id },
            isAvailable: true
        })
            .populate('owner_id')
            .populate('location')
            .populate('currency')
            .populate('imageUrl');
        return { message: dorms, httpCode: 200 };
    } catch (error) {
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}

export const postReviewForDorm = async (user_id: string, dorm_id: string, stars: number, comment: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        new Review({
            user_id,
            dorm_id,
            stars,
            comment
        }).save({ session });

        await session.commitTransaction();
        session.endSession();

        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}

export const getSavedDorms = async (user_id: string) => {
  try {
    const savedData: SavedSchemaInterface | null = await Saved.findOne({
      user_id,
    }).populate("dorm_ids");

    const savedDormIds: string[] = savedData
      ? savedData.dorm_ids.map((dormId) => dormId.toString())
      : [];

    const dorms: (DormSchemaInterface & Document)[] | null = await Dorm.find({
      owner_id: { $ne: user_id },
      isAvailable: true,
    })
      .populate("owner_id")
      .populate("location")
      .populate("currency")
      .populate("imageUrl");

    const dormsWithSavedStatus = dorms.map(
      (dorm: DormSchemaInterface & Document) => ({
        ...dorm.toObject(), 
        isSaved: savedDormIds.includes(dorm._id.toString()), 
      })
    );

    return { message: dormsWithSavedStatus, httpCode: 200 };
  } catch (error) {
    return { error: "Internal Server Error", httpCode: 500 };
  }
};


export const putSavedDorm = async (user_id: string, dorm_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const saved = await Saved.findOne({ user_id }).session(session);
        const dorm = await Dorm.findById(dorm_id).session(session);

        if (!dorm) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Dorm not found', httpCode: 404 };
        }

        if (saved !== null) {
            saved.dorm_ids.push(dorm._id);
            await saved.save({ session });
        } else {
            const newSaved = new Saved({
                user_id,
                dorm_ids: [dorm_id],
            })
            await newSaved.save({ session });
        }

        await session.commitTransaction();
        session.endSession();

        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}

export const deleteSavedDorm = async (user_id: string, dorm_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const saved = await Saved.findOne({ user_id }).session(session);
        const dorm = await Dorm.findById(dorm_id).session(session);

        if (!dorm) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Dorm not found', httpCode: 404 };
        }

        if (saved) {
            const dorm_index = saved.dorm_ids.indexOf(dorm._id);

            if (dorm_index > -1) {
                saved.dorm_ids.splice(dorm_index, 1);
                await saved.save({ session });
            } else {
                await session.abortTransaction();
                session.endSession();
                return { error: 'Dorm not found in saved list', httpCode: 404 };
            }
        } else {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Saved list not found for this user', httpCode: 404 };
        }

        await session.commitTransaction();
        session.endSession();

        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}