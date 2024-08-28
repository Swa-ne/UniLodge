import { Schema, Document, ObjectId, model } from 'mongoose';

export interface CurrencySchemaInterface extends Document {
    _id: ObjectId,
    code: string,
    symbol: string,
}

const CurrencySchema: Schema = new Schema({
    code: {
        type: String,
        required: true,
    },
    symbol: {
        type: String,
        required: true,
    },
});
export const Currency = model<CurrencySchemaInterface>("Currency", CurrencySchema)