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
  components: {
    wholeBlood: {
      type: Number,
      default: 0, // Units of whole blood available
    },
    redBloodCells: {
      type: Number,
      default: 0, // Units of RBCs available
    },
    whiteBloodCells: {
      type: Number,
      default: 0, // Units of WBCs available
    },
    platelets: {
      type: Number,
      default: 0, // Units of platelets available
    },
    plasma: {
      type: Number,
      default: 0, // Units of plasma available
    },
    cryoprecipitate: {
      type: Number,
      default: 0, // Units of cryoprecipitate available
    },
  },
});

module.exports = mongoose.model("Request", requestSchema);
