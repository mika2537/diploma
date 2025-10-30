import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    driverId: { type: String, required: true },
    message: { type: String, required: true },
    status: { type: String, default: "pending" },
  },
  { timestamps: true }
);

const Notification = mongoose.model("Notification", notificationSchema);
export default Notification;
