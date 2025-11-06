import mongoose from "mongoose";

const paymentSchema = new mongoose.Schema({
  passengerId: {
    type: String,
    required: true,
  },
  amount: {
    type: Number,
    required: true,
  },
  date: {
    type: Date,
    default: Date.now,
  },
});

// ✅ Explicitly create the model and export it as default
const Payment = mongoose.model("Payment", paymentSchema);
export default Payment;
