// backend/model/Authmodel.js

// Import the mongoose module
const mongoose = require("mongoose");
const db = require("../config/db");
const bcrypt = require("bcrypt");

// Define the schema for authentication data
const authSchema = new mongoose.Schema({
  email: { type: String, unique: true },
  password: { type: String, required: true },
  type: {
    type: String,
    required: true,
    enum: ["user", "agency"], // Explicitly define user types
  },
  // User-specific fields (optional)
  name: { type: String }, // For users
  country: { type: String }, // For users
  language: { type: String }, // For users

  // Agency-specific fields (optional)
  agencyName: { type: String }, // For agencies
  location: { type: String }, // For agencies
  description: { type: String }, // For agencies
});

// Hash the password before saving it to the database
authSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next(); // Skip hashing if password hasn't changed

  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// Export the mongoose model for authentication
const Auth = mongoose.model("AUTH", authSchema);
module.exports = Auth; // Export the model
