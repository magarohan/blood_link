const mongoose = require("mongoose");

const requestSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  bloodType: {
    type: String,
    required: true,
    enum: ["A", "B", "AB", "O"], // Valid blood groups
  },
  rhFactor: {
    type: String,
    required: true,
    enum: ["+", "-"], // Positive or Negative
  },
  location: {
    type: String,
    required: true,
  },
});

module.exports = mongoose.model("Request", requestSchema);
