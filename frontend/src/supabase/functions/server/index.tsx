import express from "express";
import cors from "cors";
import morgan from "morgan";
import { MongoClient } from "mongodb";
import crypto from "crypto";
import * as kv from "./mongodb_store.ts";

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

// MongoDB setup
const MONGO_URI = process.env.MONGODB_URI ?? "";
const client = new MongoClient(MONGO_URI);
const db = client.db("ubcarpool");
const usersCollection = db.collection("users");

// ==================== AUTH ROUTES ====================

// Sign up
app.post("/make-server-ec1b9b7f/auth/signup", async (req, res) => {
  try {
    const {
      email,
      password,
      name,
      phone,
      role,
      vehicleModel,
      vehiclePlate,
      licenseNumber,
    } = req.body;

    // Check if user already exists
    const existing = await usersCollection.findOne({ email });
    if (existing) {
      return res
        .status(400)
        .json({ error: "User with this email already exists" });
    }
    // Hash password
    const hashedPassword = crypto
      .createHash("sha256")
      .update(password)
      .digest("hex");

    // Create user in MongoDB
    const userData: any = {
      email,
      name,
      phone,
      role,
      password: hashedPassword,
      createdAt: new Date().toISOString(),
    };
    if (role === "driver") {
      userData.vehicleModel = vehicleModel;
      userData.vehiclePlate = vehiclePlate;
      userData.licenseNumber = licenseNumber;
    }
    const result = await usersCollection.insertOne(userData);
    const userId = result.insertedId.toString();
    userData.id = userId;
    // Save userData in kv store for compatibility
    await kv.set(`users:${userId}`, userData);
    // Initialize wallet
    await kv.set(`wallet:${userId}`, { balance: 0, userId });
    return res.json({ user: userData });
  } catch (err: any) {
    console.error("Signup error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Login
app.post("/make-server-ec1b9b7f/auth/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    // Find user by email
    const user = await usersCollection.findOne({ email });
    if (!user) {
      return res.status(401).json({ error: "Invalid email or password" });
    }
    // Hash incoming password and compare
    const hashedPassword = crypto
      .createHash("sha256")
      .update(password)
      .digest("hex");
    if (user.password !== hashedPassword) {
      return res.status(401).json({ error: "Invalid email or password" });
    }
    // Get user data from KV (for compatibility)
    let userData = await kv.get(`users:${user._id.toString()}`);
    if (!userData) {
      userData = {
        id: user._id.toString(),
        email: user.email,
        name: user.name,
        role: user.role,
        phone: user.phone,
      };
      await kv.set(`users:${user._id.toString()}`, userData);
    }
    // You may want to generate a JWT here for production, but for now, just return user info
    return res.json({
      user: userData,
      accessToken: null,
    });
  } catch (err: any) {
    console.error("Login error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// ==================== DRIVER ROUTES ====================

// Driver dashboard
app.get("/make-server-ec1b9b7f/driver/dashboard", async (req, res) => {
  try {
    const userId = req.query.userId as string;
    if (!userId) return res.status(400).json({ error: "User ID required" });

    // Get driver's rides today
    const allRides = await kv.getByPrefix("rides:");
    const today = new Date().toISOString().split("T")[0];

    const driverRides = allRides.filter(
      (ride: any) =>
        ride.driverId === userId && ride.createdAt?.startsWith(today)
    );

    const completedRides = driverRides.filter(
      (r: any) => r.status === "completed"
    );

    const todayIncome = completedRides.reduce(
      (sum: number, r: any) => sum + (r.fare || 0),
      0
    );
    const activeRides = driverRides.filter(
      (r: any) => r.status === "accepted" || r.status === "in_progress"
    ).length;

    // Get notifications (pending requests)
    const pendingRequests = allRides.filter(
      (r: any) => r.driverId === userId && r.status === "pending"
    );

    const notifications = pendingRequests.map((r: any) => ({
      message: `${
        r.passengerName || "Зорчигч"
      } таны маршрутаар явах хүсэлт илгээсэн`,
      time: "5 мин өмнө",
      rideId: r.id,
    }));

    return res.json({
      stats: {
        todayRides: completedRides.length,
        todayIncome,
        activeRides,
        totalIncome: todayIncome, // Simplified
      },
      notifications,
    });
  } catch (err: any) {
    console.error("Dashboard load error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Create route
app.post("/make-server-ec1b9b7f/routes/create", async (req, res) => {
  try {
    const body = req.body;
    const routeId = `route_${Date.now()}`;

    const route = {
      id: routeId,
      ...body,
      createdAt: new Date().toISOString(),
    };

    await kv.set(`routes:${routeId}`, route);
    return res.json({ route });
  } catch (err: any) {
    console.error("Route creation error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Get ride requests for driver
app.get("/make-server-ec1b9b7f/rides/requests", async (req, res) => {
  try {
    const driverId = req.query.driverId as string;
    const allRides = await kv.getByPrefix("rides:");

    const requests = allRides.filter(
      (ride: any) => ride.driverId === driverId && ride.status === "pending"
    );

    return res.json({ requests });
  } catch (err: any) {
    console.error("Failed to get requests:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Accept ride request
app.put("/make-server-ec1b9b7f/rides/:rideId/accept", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const ride = await kv.get(`rides:${rideId}`);

    if (!ride) return res.status(404).json({ error: "Ride not found" });

    ride.status = "accepted";
    ride.acceptedAt = new Date().toISOString();

    await kv.set(`rides:${rideId}`, ride);
    return res.json({ ride });
  } catch (err: any) {
    console.error("Accept ride error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Reject ride request
app.put("/make-server-ec1b9b7f/rides/:rideId/reject", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const ride = await kv.get(`rides:${rideId}`);

    if (!ride) return res.status(404).json({ error: "Ride not found" });

    ride.status = "rejected";
    await kv.set(`rides:${rideId}`, ride);

    return res.json({ ride });
  } catch (err: any) {
    console.error("Reject ride error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Mark passenger seated
app.put("/make-server-ec1b9b7f/rides/:rideId/seated", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const ride = await kv.get(`rides:${rideId}`);

    if (!ride) return res.status(404).json({ error: "Ride not found" });

    ride.status = "seated";
    ride.seatedAt = new Date().toISOString();

    await kv.set(`rides:${rideId}`, ride);
    return res.json({ ride });
  } catch (err: any) {
    console.error("Seated update error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Complete ride
app.put("/make-server-ec1b9b7f/rides/:rideId/complete", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const { distance, duration } = req.body;
    const ride = await kv.get(`rides:${rideId}`);

    if (!ride) return res.status(404).json({ error: "Ride not found" });

    ride.status = "completed";
    ride.completedAt = new Date().toISOString();
    ride.distance = distance;
    ride.duration = duration;

    await kv.set(`rides:${rideId}`, ride);

    // Add to driver wallet
    const wallet = await kv.get(`wallet:${ride.driverId}`);
    wallet.balance += ride.fare || 0;
    await kv.set(`wallet:${ride.driverId}`, wallet);

    // Add transaction
    const txId = `tx_${Date.now()}`;
    await kv.set(`transactions:${txId}`, {
      id: txId,
      userId: ride.driverId,
      type: "incoming",
      amount: ride.fare,
      description: "Аяллын орлого",
      date: new Date().toISOString(),
    });

    return res.json({ ride });
  } catch (err: any) {
    console.error("Complete ride error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Cancel ride
app.put("/make-server-ec1b9b7f/rides/:rideId/cancel", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const ride = await kv.get(`rides:${rideId}`);

    if (!ride) return res.status(404).json({ error: "Ride not found" });

    ride.status = "cancelled";
    await kv.set(`rides:${rideId}`, ride);

    return res.json({ ride });
  } catch (err: any) {
    console.error("Cancel ride error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// ==================== PASSENGER ROUTES ====================

// Passenger dashboard
app.get("/make-server-ec1b9b7f/passenger/dashboard", async (req, res) => {
  try {
    const userId = req.query.userId as string;
    if (!userId) return res.status(400).json({ error: "User ID required" });

    // Get available routes
    const allRoutes = await kv.getByPrefix("routes:");
    const nearbyRoutes = allRoutes
      .filter((r: any) => r.status === "active")
      .slice(0, 5);

    // Get passenger stats
    const allRides = await kv.getByPrefix("rides:");
    const passengerRides = allRides.filter(
      (r: any) => r.passengerId === userId
    );
    const totalSpent = passengerRides
      .filter((r: any) => r.status === "completed")
      .reduce((sum: number, r: any) => sum + (r.totalAmount || 0), 0);

    return res.json({
      nearbyRoutes,
      stats: {
        totalRides: passengerRides.filter((r: any) => r.status === "completed")
          .length,
        totalSpent,
      },
    });
  } catch (err: any) {
    console.error("Passenger dashboard error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Search routes
app.post("/make-server-ec1b9b7f/routes/search", async (req, res) => {
  try {
    const { pickup, destination } = req.body;

    const allRoutes = await kv.getByPrefix("routes:");

    // Simple search - in production would use geolocation
    const results = allRoutes.filter(
      (route: any) =>
        route.status === "active" &&
        (route.startPoint?.toLowerCase().includes(pickup.toLowerCase()) ||
          route.endPoint?.toLowerCase().includes(destination.toLowerCase()))
    );

    return res.json({ routes: results });
  } catch (err: any) {
    console.error("Route search error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Request ride
app.post("/make-server-ec1b9b7f/rides/request", async (req, res) => {
  try {
    const body = req.body;
    const rideId = `ride_${Date.now()}`;

    const ride = {
      id: rideId,
      ...body,
      status: "pending",
      createdAt: new Date().toISOString(),
    };

    await kv.set(`rides:${rideId}`, ride);
    return res.json({ ride });
  } catch (err: any) {
    console.error("Ride request error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Get ride details
app.get("/make-server-ec1b9b7f/rides/:rideId", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const ride = await kv.get(`rides:${rideId}`);

    if (!ride) return res.status(404).json({ error: "Ride not found" });

    return res.json({ ride });
  } catch (err: any) {
    console.error("Get ride error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Pay for ride
app.post("/make-server-ec1b9b7f/rides/:rideId/pay", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const { userId, amount } = req.body;

    const wallet = await kv.get(`wallet:${userId}`);

    if (wallet.balance < amount) {
      return res.status(400).json({ error: "Insufficient balance" });
    }

    wallet.balance -= amount;
    await kv.set(`wallet:${userId}`, wallet);

    // Add transaction
    const txId = `tx_${Date.now()}`;
    await kv.set(`transactions:${txId}`, {
      id: txId,
      userId,
      type: "outgoing",
      amount,
      description: "Аяллын төлбөр",
      date: new Date().toISOString(),
    });

    return res.json({ success: true });
  } catch (err: any) {
    console.error("Payment error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Rate driver
app.post("/make-server-ec1b9b7f/rides/:rideId/rate", async (req, res) => {
  try {
    const rideId = req.params.rideId;
    const { rating, feedback, driverId } = req.body;

    const ride = await kv.get(`rides:${rideId}`);
    ride.rating = rating;
    ride.feedback = feedback;
    await kv.set(`rides:${rideId}`, ride);

    // Store rating
    const ratingId = `rating_${Date.now()}`;
    await kv.set(`ratings:${ratingId}`, {
      id: ratingId,
      rideId,
      driverId,
      rating,
      feedback,
      createdAt: new Date().toISOString(),
    });

    return res.json({ success: true });
  } catch (err: any) {
    console.error("Rating error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// ==================== WALLET ROUTES ====================

// Get wallet
app.get("/make-server-ec1b9b7f/wallet", async (req, res) => {
  try {
    const userId = req.query.userId as string;
    if (!userId) return res.status(400).json({ error: "User ID required" });

    const wallet = await kv.get(`wallet:${userId}`);
    const allTransactions = await kv.getByPrefix("transactions:");
    const transactions = allTransactions
      .filter((tx: any) => tx.userId === userId)
      .sort(
        (a: any, b: any) =>
          new Date(b.date).getTime() - new Date(a.date).getTime()
      );

    return res.json({
      balance: wallet?.balance || 0,
      transactions,
    });
  } catch (err: any) {
    console.error("Wallet get error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Add money to wallet
app.post("/make-server-ec1b9b7f/wallet/add", async (req, res) => {
  try {
    const { userId, amount } = req.body;

    const wallet = (await kv.get(`wallet:${userId}`)) || { balance: 0, userId };
    wallet.balance += amount;
    await kv.set(`wallet:${userId}`, wallet);

    // Add transaction
    const txId = `tx_${Date.now()}`;
    await kv.set(`transactions:${txId}`, {
      id: txId,
      userId,
      type: "add",
      amount,
      description: "Хэтэвчид мөнгө нэмэх",
      date: new Date().toISOString(),
    });

    return res.json({ success: true, balance: wallet.balance });
  } catch (err: any) {
    console.error("Add money error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Withdraw money
app.post("/make-server-ec1b9b7f/wallet/withdraw", async (req, res) => {
  try {
    const { userId, amount } = req.body;

    const wallet = await kv.get(`wallet:${userId}`);

    if (wallet.balance < amount) {
      return res.status(400).json({ error: "Insufficient balance" });
    }

    wallet.balance -= amount;
    await kv.set(`wallet:${userId}`, wallet);

    // Add transaction
    const txId = `tx_${Date.now()}`;
    await kv.set(`transactions:${txId}`, {
      id: txId,
      userId,
      type: "outgoing",
      amount,
      description: "Мөнгө татах",
      date: new Date().toISOString(),
    });

    return res.json({ success: true, balance: wallet.balance });
  } catch (err: any) {
    console.error("Withdraw error:", err);
    return res.status(500).json({ error: err.message });
  }
});

// Health check endpoint
app.get("/make-server-ec1b9b7f/health", (req, res) => {
  return res.json({ status: "ok", timestamp: new Date().toISOString() });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Express server listening on port ${PORT}`);
});
