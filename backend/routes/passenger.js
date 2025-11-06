import express from "express";
import Ride from "../models/Ride.js";
import Payment from "../models/Payment.js";

const router = express.Router();

// 📊 Passenger Dashboard API
router.get("/dashboard", async (req, res) => {
  try {
    const { userId } = req.query;

    if (!userId) {
      return res.status(400).json({ message: "User ID required" });
    }

    // ✅ Count total rides for passenger
    const totalRides = await Ride.countDocuments({ passengerId: userId });

    // ✅ Calculate total spent
    const payments = await Payment.find({ passengerId: userId });
    const totalSpent = payments.reduce((sum, p) => sum + (p.amount || 0), 0);

    // ✅ Get nearby available routes (example)
    const nearbyRoutes = await Ride.find({ seatsLeft: { $gt: 0 } })
      .limit(5)
      .select("startPoint endPoint departureTime price seatsLeft eta");

    res.json({
      stats: { totalRides, totalSpent },
      nearbyRoutes,
    });
  } catch (error) {
    console.error("Dashboard error:", error);
    res.status(500).json({ message: "Server error" });
  }
});

export default router;
