import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

const router = express.Router();

// ================== REGISTER ==================
router.post("/register", async (req, res) => {
  try {
    const {
      name,
      email,
      phone,
      password,
      role,
      vehicleModel,
      vehiclePlate,
      licenseNumber,
    } = req.body;

    // Basic validation
    if (!name || !email || !phone || !password || !role) {
      return res.status(400).json({ error: "Бүх талбарыг бөглөнө үү." });
    }

    // Check existing user
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ error: "Энэ имэйл аль хэдийн бүртгэгдсэн байна." });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const newUser = new User({
      name,
      email,
      phone,
      password: hashedPassword,
      role,
      vehicleModel: role === "driver" ? vehicleModel : null,
      vehiclePlate: role === "driver" ? vehiclePlate : null,
      licenseNumber: role === "driver" ? licenseNumber : null,
    });

    await newUser.save();

    return res.status(201).json({
      message: "Бүртгэл амжилттай!",
      user: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        role: newUser.role,
      },
    });
  } catch (err) {
    console.error("❌ Register Error:", err);
    return res.status(500).json({ error: "Серверийн алдаа гарлаа." });
  }
});

// ================== LOGIN ==================
// ================== LOGIN ==================
router.post("/login", async (req, res) => {
  try {
    const { email, password, role } = req.body;

    // Find user by email and role
    const user = await User.findOne({ email, role });
    if (!user) {
      return res.status(400).json({ error: "Хэрэглэгч олдсонгүй" });
    }

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: "Нууц үг буруу байна" });
    }

    // Generate JWT
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    // Return minimal public user data
    res.json({
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        phone: user.phone,
      },
      token,
    });
  } catch (err) {
    console.error("❌ Login Error:", err);
    res.status(500).json({ error: "Серверийн алдаа гарлаа." });
  }
});

export default router;
