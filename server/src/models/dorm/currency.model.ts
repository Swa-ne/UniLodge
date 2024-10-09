import { Schema, Document, ObjectId, model } from 'mongoose';

export interface CurrencySchemaInterface extends Document {
    _id: ObjectId,
    code: string,
    symbol: string,
}

const CurrencySchema: Schema = new Schema({
    code: {
        type: String,
        default: "PHP"
    },
    symbol: {
        type: String,
        default: "₱"
    },
});
export const Currency = model<CurrencySchemaInterface>("Currency", CurrencySchema)