import { Request, Response } from 'express';
import { UserType } from '../middlewares/token.authentication';
import { deleteSavedDorm, getDorms, getSavedDorms, postReviewForDorm, putSavedDorm } from '../services/renter.services';
import { validateRequiredFields, validateReviewCommentLength } from '../utils/input.validators';

export const getDormsController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found" });
        const { user_id } = user;
        if (!user_id) {
            return res.status(400).json({ message: 'User ID not provided' });
        }
        const dorms = await getDorms(user_id);
        if (dorms.httpCode === 200) return res.status(dorms.httpCode).json({ 'message': dorms.message });
        return res.status(dorms.httpCode).json({ 'error': dorms.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}

export const getSavedDormsController = async (
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
    const dorms = await getSavedDorms(user_id);
    if (dorms.httpCode === 200)
      return res.status(dorms.httpCode).json({ message: dorms.message });
    return res.status(dorms.httpCode).json({ error: dorms.error });
  } catch (error) {
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const postReviewController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found." });

        const { dorm_id } = req.params;
        if (!dorm_id) return res.status(404).json({ error: "Dorm not found." });

        const { stars, comment } = req.body;
        if (!validateReviewCommentLength(comment)) {
            return res.status(413).json({ error: "Description contains too many words. Please shorten your description." });
        }

        if (!stars) return res.status(404).json({ error: "Stars cannot be undefined." });

        const dorm_post_update = await postReviewForDorm(
            user.user_id,
            dorm_id,
            stars,
            comment
        );

        if (dorm_post_update.httpCode === 200) return res.status(dorm_post_update.httpCode).json({ 'message': dorm_post_update.message });

        return res.status(dorm_post_update.httpCode).json({ 'error': dorm_post_update.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}

export const putSavedDormController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found." });

        const { dorm_id } = req.params;
        if (!dorm_id) return res.status(404).json({ error: "Dorm not found." });

        const dorm_post_update = await putSavedDorm(
            user.user_id,
            dorm_id,
        );

        if (dorm_post_update.httpCode === 200) return res.status(dorm_post_update.httpCode).json({ 'message': dorm_post_update.message });

        return res.status(dorm_post_update.httpCode).json({ 'error': dorm_post_update.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}
export const deleteSavedDormController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) return res.status(404).json({ error: "User not found." });

        const { dorm_id } = req.params;
        if (!dorm_id) return res.status(404).json({ error: "Dorm not found." });

        const dorm_post_update = await deleteSavedDorm(
            user.user_id,
            dorm_id,
        );

        if (dorm_post_update.httpCode === 200) return res.status(dorm_post_update.httpCode).json({ 'message': dorm_post_update.message });

        return res.status(dorm_post_update.httpCode).json({ 'error': dorm_post_update.error });
    } catch (error) {
        return res.status(500).json({ 'error': 'Internal Server Error' });
    }
}