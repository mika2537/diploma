import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  phone: String,
  password: String,
  role: { type: String, enum: ["driver", "passenger"], required: true },
  vehicleModel: String,
  vehiclePlate: String,
  licenseNumber: String,
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("User", userSchema);
