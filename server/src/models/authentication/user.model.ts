import mongoose, { Schema, Document, ObjectId } from 'mongoose';

export interface UserSchemaInterface extends Document {
    _id: ObjectId,
    first_name: string,
    middle_name?: string,
    last_name: string,
    username: string,
    full_name: string,
    bio?: string,
    profile_picture_url: string,
    personal_email: string,
    personal_number?: string,
    birthday: Date,
    password_hash: string,
    valid_email: boolean,
    valid_landlord: boolean,
    refresh_token_version: string,
    createdAt?: Date,
    updatedAt?: Date,
}

const UserSchema: Schema = new Schema({
    first_name: {
        type: String,
        required: [true, 'Please enter your first name.'],
    },
    middle_name: {
        type: String,
    },
    last_name: {
        type: String,
        required: [true, 'Please enter your last name.'],
    },
    username: {
        type: String,
        required: [true, 'Please enter your username.'],
    },
    full_name: {
        type: String,
        required: [true, 'Please enter your full name.'],
    },
    bio: {
        type: String,
    },
    profile_picture_url: {
        type: String,
        default: "IMAGE URL HERE",
        required: [true, 'Please enter your personal Email.'],
    },
    personal_email: {
        type: String,
        required: [true, 'Please enter your personal Email.'],
        unique: true,
    },
    personal_number: {
        type: String,
        unique: true,
    },
    birthday: {
        type: Date,
        required: [true, 'Please enter your birthday.'],
    },
    password_hash: {
        type: String,
        required: [true, 'Please enter your password.'],
    },
    valid_email: {
        type: Boolean,
        default: false
    },
    valid_landlord: {
        type: Boolean,
        default: false
    },
    refresh_token_version: {
        type: Number,
        default: 0
    }
}, {
    timestamps: true,
});

export const User = mongoose.model<UserSchemaInterface>("User", UserSchema)

export interface UserValidCodeSchemaInterface extends Document {
    user_id: ObjectId,
    code: string,
    expiresAt: Date
}

const UserValidCodeSchema: Schema = new Schema({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        default: null,
    },
    code: {
        type: String,
        required: true,
    },
    expiresAt: {
        type: Date,
        required: true,
    },
})

export const UserValidCode = mongoose.model<UserValidCodeSchemaInterface>("UserValidCode", UserValidCodeSchema)
