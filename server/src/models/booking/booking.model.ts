import { Document, model, ObjectId, Schema } from "mongoose";

export interface BookingSchemaInterface extends Document {
  _id: ObjectId;
  user_id: ObjectId;
  listing_id: ObjectId;
  propertyType: string;
  price: number;
  status: string;
  createdAt?: Date;
  updatedAt?: Date;
}

const BookingSchema = new Schema(
  {
    user_id: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    listing_id: {
      type: Schema.Types.ObjectId,
      ref: "Dorm",
      required: true,
    },
    propertyType: {
      type: String,
      required: true,
    },
    price: {
      type: Number,
      required: true,
    },
    status: {
      type: String,
      enum: ["Pending", "Accepted", "Rejected", "Paid", "Cancelled"],
      default: "Pending",
    },
  },
  {
    timestamps: true,
  }
);

export const Booking = model<BookingSchemaInterface>("Booking", BookingSchema);
