import express from "express";
import Ride from "../models/Ride.js";
import Notification from "../models/Notification.js";

const router = express.Router();

router.get("/dashboard", async (req, res) => {
  const { userId } = req.query;

  try {
    if (!userId) {
      return res.status(400).json({ message: "User ID required" });
    }

    // ✅ Get start and end of today
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date();
    endOfDay.setHours(23, 59, 59, 999);

    // ✅ Get all rides for this driver
    const rides = await Ride.find({ driverId: userId });

    // ✅ Today’s rides (using createdAt, requires timestamps in schema)
    const todayRides = rides.filter(
      (r) =>
        r.createdAt &&
        new Date(r.createdAt) >= startOfDay &&
        new Date(r.createdAt) <= endOfDay
    );

    // ✅ Completed rides for income calculation
    const completedRides = todayRides.filter((r) => r.status === "completed");

    // ✅ Calculate total income
    const todayIncome = completedRides.reduce(
      (total, r) => total + (r.fare || r.price || 0),
      0
    );

    // ✅ Active rides
    const activeRides = rides.filter((r) =>
      ["accepted", "in_progress"].includes(r.status)
    ).length;

    // ✅ Get pending notifications
    const notifications = await Notification.find({
      driverId: userId,
      status: "pending",
    })
      .sort({ createdAt: -1 })
      .limit(5);

    res.json({
      stats: {
        todayRides: todayRides.length,
        todayIncome,
        activeRides,
        totalIncome: todayIncome, // Simplified
      },
      notifications,
    });
  } catch (err) {
    console.error("Driver dashboard error:", err);
    res.status(500).json({ error: err.message });
  }
});

export default router;
