import mongoose from "mongoose";

const rideSchema = new mongoose.Schema({
  driverId: {
    type: String,
    required: true,
  },
  passengerId: {
    type: String,
    required: false,
  },
  startPoint: {
    type: String,
    required: true,
  },
  endPoint: {
    type: String,
    required: true,
  },
  departureTime: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  seatsLeft: {
    type: Number,
    required: true,
  },
  eta: {
    type: String,
    required: false,
  },
});

const Ride = mongoose.model("Ride", rideSchema);
export default Ride;
